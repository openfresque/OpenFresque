module Transactions
  class CreateTransaction
    include SimpleCommand

    def initialize(participation:, product_configuration:, custom_price:, coupon_code:)
      @participation = participation
      @product_configuration = product_configuration
      @custom_price = custom_price
      @coupon_code = coupon_code
      compute_transaction_prices
    end

    def call
      if coupon_code.present?
        create_transaction_with_coupon
      else
        create_transaction_without_coupon
      end
    end

    def create_transaction_with_coupon
      command = Coupons::ConsumeCoupon.new(
        training_session: @participation.training_session,
        code: @coupon_code
      )
      coupon = command.call

      if command.errors.present?
        errors.add(:base, command.errors.full_messages.to_sentence)
        return
      end

      product_configuration = ProductConfiguration.find_by!(
        product: coupon_product,
        country: participation.training_session.country
      )

      transaction = Transaction.create!(
        participation:,
        product_configuration:,
        status: Transaction::Success,
        before_tax_price_cents: 0,
        tax_cents: 0,
        after_tax_price_cents: 0,
        currency: product_configuration.currency,
        coupon:
      )

      participation.update!(status: Participation::Pending)

      transaction
    end

    def create_transaction_without_coupon
      if use_custom_price? && custom_price.to_i <= 0
        errors.add(:base, "Le montant doit être supérieur 0")
        return
      end

      status = product_configuration.after_tax_price.zero? ? Transaction::Success : Transaction::Pending
      Transaction.create!(
        participation:,
        product_configuration:,
        status:,
        before_tax_price_cents:,
        tax_cents:,
        after_tax_price_cents:,
        currency: product_configuration.currency
      )
    end

    private

    def coupon_product
      Product.find_by!(
        identifier: "COUPON",
        category: participation.training_session.category
      )
    end

    def tax_rate
      product_configuration.tax_rate
    end

    def use_custom_price?
      product_configuration.price_modifiable? && custom_price.present?
    end

    def compute_transaction_prices
      if use_custom_price?
        currency = Money::Currency.find(product_configuration.currency)
        @after_tax_price_cents = (custom_price.to_f * currency.subunit_to_unit).to_i
        @before_tax_price_cents = (@after_tax_price_cents / (1 + tax_rate.fdiv(100))).to_i
        @tax_cents = @after_tax_price_cents - @before_tax_price_cents
      else
        @after_tax_price_cents = product_configuration.after_tax_price_cents
        @tax_cents = product_configuration.tax_cents
        @before_tax_price_cents = product_configuration.before_tax_price_cents
      end
    end

    attr_reader :participation,
                :product_configuration,
                :custom_price,
                :after_tax_price_cents,
                :tax_cents,
                :before_tax_price_cents,
                :coupon_code
  end
end
