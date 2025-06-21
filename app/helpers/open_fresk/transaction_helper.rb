module OpenFresk
  module TransactionHelper
    def product_configuration_full_display(transactions)
      if transactions.last.present? && transactions.last.refunded? && transactions.last.participation.declined?
        content = t("invitations.canceled_refunded")
      elsif transactions.last.present? && transactions.last.refunded?
        content = t("invitations.refunded")
      elsif transactions.last.present? && transactions.last.participation.declined?
        content = t("invitations.canceled")
      elsif transactions.last.present?
        content = "#{transactions.last&.product_configuration&.display_name} (#{transactions.last&.after_tax_price&.format})"
      end
      content_tag(:div, class: "small") do
        content
      end
    end
  end
end