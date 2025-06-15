module OpenFresk
  class Country < ApplicationRecord
    self.table_name = 'countries'
    has_many :product_configurations, dependent: :destroy
    has_many :products, through: :product_configurations
  end
end