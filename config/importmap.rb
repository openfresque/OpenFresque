# config/importmap.rb (inside the engine)
# Pin the entrypoint...
pin "open_fresk", to: "open_fresk.js"
# …and all controllers under the controllers folder:
pin_all_from File.expand_path("../app/javascript/open_fresk/controllers", __dir__),
             under: "open_fresk/controllers"