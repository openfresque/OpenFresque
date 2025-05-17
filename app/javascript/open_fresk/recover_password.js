// engines/open_fresk/app/javascript/open_fresk/recover_password.js

function recoverPassword() {
  const tokenInput = document.querySelector("#recovery_token");
  if (!tokenInput) return;

  const urlParams = new URLSearchParams(window.location.search);
  const recoveryToken = urlParams.get("recovery_token");

  if (recoveryToken) {
    document.querySelectorAll(".language_modal_url").forEach((el) => {
      el.href = `${el.href}&recovery_token=${recoveryToken}`;
    });
  }
}

document.addEventListener("DOMContentLoaded", recoverPassword);
document.addEventListener("turbo:load", recoverPassword);
