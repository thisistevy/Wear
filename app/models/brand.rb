class Brand < ApplicationRecord
  # products
  has_many :products, dependent: :destroy
  has_many :collection_points, dependent: :nullify
  has_one_attached :logo
  geocoded_by :address
  # validation
  validates :name, presence: true, uniqueness: { message: "this brand already exists" }
  validates :description, presence: true,
                          length: { minimum: 15, message: "description must be at least 15 character-long" }
  after_validation :geocode, if: :will_save_change_to_address?
end
