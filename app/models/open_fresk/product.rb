class Product < ApplicationRecord
  before_save :format_identifier
  has_many :product_configurations, dependent: :destroy

  validates :identifier, :category, :audience, presence: true

  scope :category, ->(category) { where(category:) }
  scope :charged, -> { where(charged: true) }
  scope :audience, ->(audience) { where(audience:) }
  string_enum category: %i[atelier formation].freeze
  string_enum audience: %i[personal general_public education public_sector company association inter_company].freeze

  def self.[](attribute)
    arel_table[attribute]
  end

  def format_identifier
    self.identifier = identifier.upcase.gsub(" ", "_")
  end
end
