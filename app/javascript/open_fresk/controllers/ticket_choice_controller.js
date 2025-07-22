import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["customPrice"];

  connect() {
    this.updateCustomPriceRequirement();
  }

  handleRadioChange() {
    this.updateCustomPriceRequirement();
  }

  updateCustomPriceRequirement() {
    const selectedRadio = this.element.querySelector(
      'input[name="product_configuration_id"]:checked'
    );

    if (this.hasCustomPriceTarget) {
      if (
        selectedRadio &&
        selectedRadio.getAttribute("price_modifiable") === "true"
      ) {
        this.customPriceTarget.required = true;
      } else {
        this.customPriceTarget.required = false;
      }
    }
  }
}
