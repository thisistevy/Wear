import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

// Keys must stay in sync with CollectionPoint::POINT_TYPES.
const MARKER_COLORS = {
  store: '#AAD576',
  collection: '#4A90D9',
  recycling: '#F4A259',
  resale: '#E08E6D',
};

const TYPE_LABELS = {
  store: 'Shop',
  collection: 'Drop-off point',
  recycling: 'Recycling point',
  resale: 'Second-hand',
};

// How many rows the side list paints at once. There are ~700 markers, and
// rendering a row for each doubled the page's DOM for rows nobody scrolls to.
const MAX_LIST_ITEMS = 50;

const fitMapToMarkers = (map, markers, duration = 0) => {
  if (!markers.length) return;
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration });
};

// Good enough to rank places inside one screenful. A real great-circle
// distance would be wasted here: we only need an ordering, not a number to
// show. Longitude degrees shrink towards the poles, hence the cos() factor.
const roughDistance = (center, data) => {
  const dx = (data.lng - center.lng) * Math.cos((center.lat * Math.PI) / 180);
  const dy = data.lat - center.lat;
  return (dx * dx) + (dy * dy);
};

// Side list of the places currently framed by the map. It reads the same
// `entries` the markers were built from, so the list and the map can't drift
// apart. Returns a refresh function the caller wires to map moves and filters.
const createPlaceList = (map, entries, state) => {
  const container = document.getElementById('map-list');
  if (!container) return () => {};

  const countEl = container.querySelector('.map-list-count');
  const listEl = container.querySelector('.map-list-items');

  const focusPlace = ({ data, marker }) => {
    // Never zoom back out: clicking a row when you're already close in should
    // pan, not throw away the zoom level you chose.
    map.flyTo({
      center: [data.lng, data.lat],
      zoom: Math.max(map.getZoom(), 15),
      duration: 900,
    });
    if (!marker.getPopup().isOpen()) marker.togglePopup();
  };

  const buildItem = (entry) => {
    const { data } = entry;

    const button = document.createElement('button');
    button.type = 'button';
    button.className = 'map-list-item';

    const name = document.createElement('span');
    name.className = 'map-list-name';
    // textContent rather than innerHTML throughout: these names and addresses
    // come from an open data import, so they are untrusted strings.
    name.textContent = data.name || 'Unnamed place';

    const type = document.createElement('span');
    type.className = 'map-list-type';
    type.textContent = TYPE_LABELS[data.type] || data.type;
    type.style.setProperty('--dot-color', MARKER_COLORS[data.type] || MARKER_COLORS.store);

    const address = document.createElement('span');
    address.className = 'map-list-address';
    address.textContent = data.address || '';

    button.append(name, type, address);
    button.addEventListener('click', () => focusPlace(entry));

    const item = document.createElement('li');
    item.appendChild(button);
    return item;
  };

  const refresh = () => {
    const bounds = map.getBounds();
    const center = map.getCenter();

    const inView = entries.filter(({ data }) => (
      (state.selected === null || data.categories.includes(state.selected))
      && bounds.contains([data.lng, data.lat])
    ));
    inView.sort((a, b) => roughDistance(center, a.data) - roughDistance(center, b.data));

    const shown = inView.slice(0, MAX_LIST_ITEMS);
    const fragment = document.createDocumentFragment();
    shown.forEach(entry => fragment.appendChild(buildItem(entry)));
    listEl.innerHTML = '';
    listEl.appendChild(fragment);

    if (!inView.length) {
      countEl.textContent = 'No places here — move the map or zoom out.';
    } else if (inView.length > shown.length) {
      countEl.textContent = `Nearest ${shown.length} of ${inView.length} places — zoom in to narrow down`;
    } else {
      countEl.textContent = `${inView.length} place${inView.length > 1 ? 's' : ''} in view`;
    }
  };

  return refresh;
};

// Filters markers from the legend chips.
//
// Selection is exclusive: picking a chip shows that category only, and picking
// it again clears the filter. Multi-select was tried first and read as broken,
// because most points carry several categories (a charity shop both collects
// and resells), so switching one chip off still left it matching another and
// barely anything disappeared.
const initFilters = (map, entries, state, onChange) => {
  const container = document.getElementById('map-filters');
  if (!container) return;

  const buttons = Array.from(container.querySelectorAll('.map-filter'));

  const apply = ({ animate = true } = {}) => {
    const visible = [];
    entries.forEach(({ data, marker }) => {
      const shown = state.selected === null || data.categories.includes(state.selected);
      marker.getElement().style.display = shown ? '' : 'none';
      if (shown) visible.push(data);
    });

    // Only the chosen chip is highlighted. Highlighting all of them at rest
    // read as "four filters applied" when in fact none was.
    buttons.forEach((button) => {
      const on = button.dataset.category === state.selected;
      button.classList.toggle('is-active', on);
      button.setAttribute('aria-pressed', String(on));
    });

    if (animate) fitMapToMarkers(map, visible, 800);
    onChange();
  };

  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      state.selected = state.selected === button.dataset.category ? null : button.dataset.category;
      apply();
    });
  });

  // Set the chips' initial pressed state without re-framing the map:
  // fitMapToMarkers has already been called with every marker at this point.
  apply({ animate: false });
};

// Wires the page's own search bar to the map, replacing Mapbox's floating
// in-map geocoder: one search box on the page instead of two competing ones.
const initPlaceSearch = (map, accessToken) => {
  const form = document.getElementById('map-search');
  if (!form) return;

  const input = form.querySelector('input[type="search"], input[type="text"]');
  const feedback = document.getElementById('map-search-feedback');
  const queryLine = document.getElementById('map-list-query');

  // Progress and failures stay under the search bar, where the user is looking
  // while typing. Success doesn't: the result belongs on top of the list it
  // just changed, so the panel says what it is showing.
  const say = (message, isError) => {
    if (!feedback) return;
    feedback.textContent = message;
    feedback.classList.toggle('is-error', Boolean(isError));
  };

  const showQuery = (query) => {
    if (!queryLine) return;
    queryLine.textContent = query ? `Results for “${query}”` : '';
  };

  form.addEventListener('submit', async (event) => {
    event.preventDefault();
    const query = input.value.trim();
    if (!query) return;

    say('Searching…', false);
    const endpoint = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json`;

    try {
      const response = await fetch(`${endpoint}?access_token=${accessToken}&limit=1`);
      if (!response.ok) throw new Error(`Geocoding failed (${response.status})`);

      const { features } = await response.json();
      if (!features.length) {
        say(`No place found for “${query}”.`, true);
        showQuery('');
        return;
      }

      const place = features[0];
      // bbox is only present for areas (cities, regions); points like a street
      // address only carry a centre, so fall back to a close zoom on it.
      if (place.bbox) {
        map.fitBounds(place.bbox, { padding: 40, duration: 1200 });
      } else {
        map.flyTo({ center: place.center, zoom: 14, duration: 1200 });
      }
      say('', false);
      showQuery(query);
    } catch (error) {
      say('Search is unavailable right now.', true);
      showQuery('');
    }
  });
};

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  if (mapElement) { // only build a map if there's a div#map to inject into
    const accessToken = mapElement.dataset.mapboxApiKey;
    mapboxgl.accessToken = accessToken;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });
    const markers = JSON.parse(mapElement.dataset.markers);
    const entries = markers.map((data) => {
      const popup = new mapboxgl.Popup().setHTML(data.info_window);
      const marker = new mapboxgl.Marker({ color: MARKER_COLORS[data.type] || MARKER_COLORS.store })
        .setLngLat([data.lng, data.lat])
        .setPopup(popup)
        .addTo(map);
      return { data, marker };
    });

    // Shared by the chips and the list, so there is one answer to "what is
    // being filtered" rather than two that can disagree.
    const state = { selected: null };
    const refreshList = createPlaceList(map, entries, state);

    fitMapToMarkers(map, markers);
    initFilters(map, entries, state, refreshList);
    initPlaceSearch(map, accessToken);

    // The list follows the map: panning or zooming re-reads the viewport.
    map.on('moveend', refreshList);
    map.on('load', refreshList);
  };
};

export { initMapbox };
