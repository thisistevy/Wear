import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const fitMapToMarkers = (map, markers, duration = 0) => {
  if (!markers.length) return;
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([marker.lng, marker.lat]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration });
};

// Toggles marker visibility from the legend chips. Markers carry a list of
// categories rather than a single type, because a shop that buys second-hand
// is both a "store" and a "sell" point and must answer to both filters.
const initFilters = (map, entries) => {
  const container = document.getElementById('map-filters');
  if (!container) return;

  const buttons = Array.from(container.querySelectorAll('.map-filter'));

  const apply = () => {
    const active = buttons
      .filter(button => button.classList.contains('is-active'))
      .map(button => button.dataset.category);

    const visible = [];
    entries.forEach(({ data, marker }) => {
      const shown = data.categories.some(category => active.includes(category));
      marker.getElement().style.display = shown ? '' : 'none';
      if (shown) visible.push(data);
    });

    fitMapToMarkers(map, visible, 800);
  };

  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      button.classList.toggle('is-active');
      button.setAttribute('aria-pressed', button.classList.contains('is-active'));
      apply();
    });
  });
};

const MARKER_COLORS = {
  store: '#AAD576',
  collection: '#4A90D9',
  recycling: '#F4A259',
};

// Wires the page's own search bar to the map, replacing Mapbox's floating
// in-map geocoder: one search box on the page instead of two competing ones.
const initPlaceSearch = (map, accessToken) => {
  const form = document.getElementById('map-search');
  if (!form) return;

  const input = form.querySelector('input[type="search"], input[type="text"]');
  const feedback = document.getElementById('map-search-feedback');

  const say = (message, isError) => {
    if (!feedback) return;
    feedback.textContent = message;
    feedback.classList.toggle('is-error', Boolean(isError));
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
      say(place.place_name, false);
    } catch (error) {
      say('Search is unavailable right now.', true);
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

    fitMapToMarkers(map, markers);
    initFilters(map, entries);
    initPlaceSearch(map, accessToken);
  };
};

export { initMapbox };
