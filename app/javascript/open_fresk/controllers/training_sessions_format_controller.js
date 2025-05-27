import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="training-sessions-format"
export default class extends Controller {
  static targets = ["onsite", "online", "onsiteButton", "onlineButton", "address", "url"]

  connect() {
    this.update()
  }

  click() {
    this.update()
  }

  update() {
    const onlineDiv = this.hasOnlineTarget
    const url = this.hasUrlTarget
    if (this.onsiteButtonTarget.checked == true) {
      if (onlineDiv) this.onlineTarget.classList.add("d-none")
      this.onsiteTarget.classList.remove("d-none")
      if (url) this.urlTarget.required = false
      if (url) this.urlTarget.value = ""
      this.addressTarget.required = true
    } else if (this.onlineButtonTarget.checked == true) {
      this.onsiteTarget.classList.add("d-none")
      if (onlineDiv) this.onlineTarget.classList.remove("d-none")
      if (url) this.urlTarget.required = true
      this.addressTarget.required = false
      this.addressTarget.value = ""
    }
  }
}
