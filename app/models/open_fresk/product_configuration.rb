module OpenFresk
  class ProductConfiguration < ApplicationRecord
    self.table_name = 'product_configurations'

    belongs_to :product, optional: false
    belongs_to :country, optional: false
    has_many :product_configuration_sessions, dependent: :destroy

    monetize :before_tax_price_cents,
             :after_tax_price_cents,
             :tax_cents,
             with_model_currency: :currency

    validates :display_name,
              presence: true

    validates_uniqueness_of :country_id, scope: :product_id

    before_save :set_currency, unless: :currency

    delegate :price_modifiable?, to: :product

    def coupon?
      product.identifier == "COUPON"
    end

    private

      def set_currency
        self.currency = country.currency_code
      end
  end
end