module OpenFresk
  module PaymentHelper
    def ticket_text(session)
      country = session.country
      cheapest_charged_product = session.product_configurations
                                 .joins(:product)
                                 .where(country: country)
                                 .where(products: {category: session.category})
                                 .order(after_tax_price_cents: :asc)
                                 .first
      if cheapest_charged_product.present?
        min_price_formated = cheapest_charged_product.after_tax_price.format
        t("training_sessions.price", price: min_price_formated)
      else
        t("training_sessions.free")
      end
    end

    def ticket_type(product_configuration)
      if product_configuration.product.charged?
        product_configuration.display_name
      else
        t("training_sessions.free")
      end
    end
  end

end