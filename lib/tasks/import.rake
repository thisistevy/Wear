require "net/http"
require "json"

namespace :import do
  desc "Import textile drop-off, recycling and second-hand points from ADEME open data. Usage: rails 'import:textile_points[Paris]'"
  task :textile_points, [:city] => :environment do |_task, args|
    city = args[:city].presence || "Paris"

    # "Acteurs de l'économie circulaire - Que faire de mes objets et déchets ?"
    # Public dataset, no API key required.
    dataset = "wvw1zecq4f4gyvonve5j0hr7"
    endpoint = "https://data.ademe.fr/data-fair/api/v1/datasets/#{dataset}/lines"

    # Only these sub-categories are clothing-related; the dataset also covers
    # furniture, electronics, etc.
    textile = %w[vetement chaussures linge_de_maison].freeze

    # What the user can do there -> the map filter it answers to.
    action_to_category = {
      "donner" => "collection",
      "trier" => "recycling",
      "acheter" => "store",
      "revendre" => "sell",
    }.freeze

    # What kind of place it is -> the marker colour.
    actor_to_point_type = {
      "pav_public" => "recycling",
      "pav_prive" => "recycling",
      "pav_ponctuel" => "recycling",
      "decheterie" => "recycling",
      "ess" => "collection",
      "commerce" => "store",
      "artisan" => "store",
    }.freeze

    uri = URI(endpoint)
    uri.query = URI.encode_www_form(size: 1000, qs: "ville:#{city}", q: "vetement")

    puts "Fetching textile points for #{city}…"
    response = Net::HTTP.get_response(uri)
    abort "ADEME API returned #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    rows = JSON.parse(response.body).fetch("results")
    puts "#{rows.size} rows returned."

    imported = 0
    updated = 0
    skipped = 0

    rows.each do |row|
      # Online-only actors have no shop to visit, so they would be phantom pins.
      next skipped += 1 if row["type_dacteur"] == "acteur_digital"
      next skipped += 1 if row["latitude"].blank? || row["longitude"].blank?
      next skipped += 1 if row["nom"].blank? || row["adresse"].blank?

      services = row["propositions_de_services"]
      services = JSON.parse(services) if services.is_a?(String)

      categories = Array(services).flat_map { |service|
        next [] if (Array(service["sous_categories"]) & textile).empty?

        action_to_category[service["action"]]
      }.compact.uniq

      next skipped += 1 if categories.empty?

      point = CollectionPoint.find_or_initialize_by(
        source: "ademe",
        external_id: row["identifiant"],
      )
      was_new = point.new_record?

      point.assign_attributes(
        name: row["nom"],
        address: [row["adresse"], row["code_postal"], row["ville"]].reject(&:blank?).join(", "),
        latitude: row["latitude"],
        longitude: row["longitude"],
        point_type: actor_to_point_type.fetch(row["type_dacteur"], "collection"),
        categories: categories,
        website: row["site_web"],
        description: row["horaires_description"],
      )

      if point.save
        was_new ? imported += 1 : updated += 1
      else
        skipped += 1
        warn "  skipped #{row['nom']}: #{point.errors.full_messages.join(', ')}"
      end
    end

    puts "Done. #{imported} created, #{updated} updated, #{skipped} skipped."
    puts "#{CollectionPoint.count} collection points in total."
  end
end
