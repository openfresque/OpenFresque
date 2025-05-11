// app/assets/javascripts/open_fresk/application.js
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()
eagerLoadControllersFrom("controllers", application)
export { application }

console.log("🔌 open_fresk.js loaded")