import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
import "open_fresk/recover_password";

const application = Application.start();
eagerLoadControllersFrom("open_fresk/controllers", application);

console.log("🔌 open_fresk.js loaded");
