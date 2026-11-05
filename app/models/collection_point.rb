class CollectionPoint < ApplicationRecord
  belongs_to :brand, optional: true
  geocoded_by :address
  # Imported points already carry coordinates from the source, so geocoding
  # them again would burn API calls to recompute what we already know.
  after_validation :geocode, if: -> { will_save_change_to_address? && latitude.blank? }

  POINT_TYPES = %w[collection recycling store resale].freeze
  # Must stay in sync with the filter buttons in maps/index and with
  # MARKER_COLORS in app/javascript/plugins/init_mapbox.js.
  CATEGORIES = %w[store collection recycling sell].freeze

  validates :name, presence: true
  validates :address, presence: true
  validates :point_type, inclusion: { in: POINT_TYPES }
  validate :categories_are_known

  private

  def categories_are_known
    unknown = categories.to_a - CATEGORIES
    return if unknown.empty?

    errors.add(:categories, "unknown: #{unknown.join(', ')}")
  end
end
