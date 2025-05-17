pin "open_fresk", to: "open_fresk/application.js", preload: true
pin_all_from File.expand_path("../app/javascript/open_fresk/controllers", __dir__),
             under: "open_fresk/controllers"
pin "open_fresk/recover_password",
             to: "open_fresk/recover_password.js",
             preload: true