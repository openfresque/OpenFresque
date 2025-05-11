import { Application } from "@hotwired/stimulus";
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";

// start Stimulus and load every controller under "javascripts/open_fresk/controllers"
const application = Application.start();
eagerLoadControllersFrom("open_fresk/controllers", application);

export { application };