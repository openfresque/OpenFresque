module OpenFresk
  class ProductConfigurationSession < ApplicationRecord
    self.table_name = 'product_configuration_sessions'

    belongs_to :product_configuration
    belongs_to :training_session

    validates_uniqueness_of :product_configuration, scope: [:training_session]
  end
end