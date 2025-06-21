module OpenFresk
  class Transaction < ApplicationRecord
    self.table_name = 'transactions'

    belongs_to :participation
    belongs_to :product_configuration

    string_enum status: %i[pending success failure refund].freeze

    monetize :before_tax_price_cents,
             :after_tax_price_cents,
             :tax_cents,
             with_model_currency: :currency

    validates_uniqueness_of :payment_intent_id, allow_nil: true

    delegate :user, to: :participation
    delegate :training_session, :contact, to: :participation

    validates :participation_id, :product_configuration_id, presence: true

    def charged?
      product_configuration&.product&.charged?
    end
    def refunded?
      status == Transaction::Refund
    end

    def invoice_number
      "B#{updated_at.year}-#{id.to_s.rjust(6, '0')}"
    end
  end
end