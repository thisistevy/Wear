class Listing < ApplicationRecord
  belongs_to :user
  has_one_attached :picture

  CONDITIONS = ["neuf", "très bon état", "bon état", "usé"].freeze
  LISTING_TYPES = %w[vente don échange].freeze
  STATUSES = %w[disponible réservé vendu].freeze

  validates :title, presence: true
  validates :description, length: { minimum: 6, message: "la description doit faire au moins 6 caractères" }
  validates :condition, inclusion: { in: CONDITIONS }
  validates :listing_type, inclusion: { in: LISTING_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :gender, inclusion: { in: ["Woman", "Man"] }
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :available, -> { where(status: "disponible") }

  before_validation :set_default_status

  private

  def set_default_status
    self.status ||= "disponible"
  end
end
