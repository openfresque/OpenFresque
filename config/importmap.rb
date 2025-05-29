pin "open_fresk", to: "open_fresk/application.js", preload: true
pin_all_from File.expand_path("../app/javascript/open_fresk/controllers", __dir__),
             under: "open_fresk/controllers"
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"