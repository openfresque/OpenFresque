import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

const application = Application.start();
eagerLoadControllersFrom("open_fresk/controllers", application);

console.log("🔌 open_fresk.js loaded");
