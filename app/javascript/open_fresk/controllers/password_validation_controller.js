import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="password-validation"
export default class extends Controller {
  static targets = [
    "firstInput",
    "secondInput",
    "size",
    "lowerUpper",
    "numbers",
    "specialCharacters",
    "validRepeat",
    "submit",
  ];

  connect() {}

  validateInput(input) {
    let firstPassword = this.firstInputTarget.value;
    let secondPassword = this.secondInputTarget.value;
    let size = firstPassword.length >= 12;
    let majMin = /(?=\S*[a-z+])(?=\S*[A-Z+])/.test(firstPassword);
    let number = /(?=\S*[0-9+])/.test(firstPassword);
    let special = /(?=\S*[@:,\-?*_()!#$%^&+=])/.test(firstPassword);
    let repeat = secondPassword === firstPassword;
    let valid = size && majMin && number && special && repeat;

    if (size) {
      this.sizeTarget.classList.add("text-primary");
      this.sizeTarget.classList.remove("text-danger");
    } else {
      this.sizeTarget.classList.remove("text-primary");
      this.sizeTarget.classList.add("text-danger");
    }

    if (majMin) {
      this.lowerUpperTarget.classList.add("text-primary");
      this.lowerUpperTarget.classList.remove("text-danger");
    } else {
      this.lowerUpperTarget.classList.remove("text-primary");
      this.lowerUpperTarget.classList.add("text-danger");
    }

    if (number) {
      this.numbersTarget.classList.add("text-primary");
      this.numbersTarget.classList.remove("text-danger");
    } else {
      this.numbersTarget.classList.remove("text-primary");
      this.numbersTarget.classList.add("text-danger");
    }

    if (special) {
      this.specialCharactersTarget.classList.add("text-primary");
      this.specialCharactersTarget.classList.remove("text-danger");
    } else {
      this.specialCharactersTarget.classList.remove("text-primary");
      this.specialCharactersTarget.classList.add("text-danger");
    }

    if (repeat) {
      this.validRepeatTarget.classList.remove("text-danger");
      this.validRepeatTarget.classList.add("text-primary");
    } else {
      this.validRepeatTarget.classList.add("text-danger");
      this.validRepeatTarget.classList.remove("text-primary");
    }

    this.submitTarget.disabled = !valid;
  }

  firstInputValidation() {
    this.validateInput(this.firstInputTarget);
  }

  secondInputValidation() {
    this.validateInput(this.secondInputTarget);
  }
}
