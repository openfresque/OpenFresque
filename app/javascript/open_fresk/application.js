// OpenFresk/app/javascript/open_fresk/application.js
import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Initialize Stimulus application
const application = Application.start()

console.log("🔥 open_fresk/application.js is running")

// Load ALL controllers under the controllers importmap namespace
// This picks up host and engine controllers pinned under "controllers/*.js"
eagerLoadControllersFrom("controllers", application)

export { application }
