Geocoder.configure(
  units: :km,
  # Nominatim's usage policy rejects requests without an identifying
  # User-Agent (returns a 403 HTML page instead of JSON).
  # https://operations.osmfoundation.org/policies/nominatim/
  http_headers: { "User-Agent" => "WearApp/1.0 (contact: contact@wear-app.live)" },
)
