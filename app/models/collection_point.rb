class CollectionPoint < ApplicationRecord
  belongs_to :brand, optional: true
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  POINT_TYPES = %w[collection recycling].freeze

  validates :name, presence: true
  validates :address, presence: true
  validates :point_type, inclusion: { in: POINT_TYPES }
end
