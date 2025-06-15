module OpenFresk
  module ProductConfigurationHelper
    def product_configuration_checkbox(session, p)
      checked = session&.product_configurations&.include?(p) ? true : false
      check_box_tag("product_configurations[]", p.id, checked, id: p.id, class: "form-check-input")
    end
  end
end