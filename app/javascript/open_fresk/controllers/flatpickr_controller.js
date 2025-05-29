import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["flatpickr"]
  static values = {
    mode: { type: String, default: "date" }
  };

  connect() {
    this.load()
  };

  load() {
    const parameters = {
      dateFormat: "Y-m-d",
      altFormat: "d-m-Y",
      locale: {
        "firstDayOfWeek": 1
      }
    };
    if (this.modeValue != "date") {
      parameters.mode = this.modeValue;
    };
    flatpickr(this.getFlatpickrElement(), parameters);
  };

  changeMode(e) {
    const select = e.currentTarget;
    this.modeValue = select.options[select.selectedIndex].dataset.mode;
    this.getFlatpickrElement().value = "";
    this.load();
  };

  getFlatpickrElement() {
    return this.hasFlatpickrTarget ? this.flatpickrTarget : this.element;
  }
}
