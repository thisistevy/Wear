class Listing < ApplicationRecord
  belongs_to :user
  has_one_attached :picture

  CONDITIONS = ["new", "very good condition", "good condition", "worn"].freeze
  LISTING_TYPES = %w[sale gift swap].freeze
  STATUSES = %w[available reserved sold].freeze

  validates :title, presence: true
  validates :description, length: { minimum: 6, message: "must be at least 6 characters long" }
  validates :condition, inclusion: { in: CONDITIONS }
  validates :listing_type, inclusion: { in: LISTING_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :gender, inclusion: { in: ["Woman", "Man"] }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :available, -> { where(status: "available") }

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= "available"
  end
end
