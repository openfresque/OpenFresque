require "font_awesome5_rails"

module OpenFresk
  class Engine < ::Rails::Engine
    isolate_namespace OpenFresk

    # Load migrations into the host app (aka "dummy" app)
    initializer :append_migrations do |app|
      unless app.root.to_s.match?(root.to_s)
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Autoload services and helpers
    initializer "open_fresk.add_autoload_paths", before: :set_autoload_paths do |app|
      # Services
      config.autoload_paths   += [root.join("app", "services")]
      config.eager_load_paths += [root.join("app", "services")]

      # Helpers (including FontAwesome5)
      helpers_path = root.join("app", "helpers")
      config.autoload_paths   += [helpers_path]
      config.eager_load_paths += [helpers_path]
    end

    # Make engine Javascript available via Sprockets
    initializer "open_fresk.assets.paths", before: :append_assets_path do |app|
      # engine’s JS:
      app.config.assets.paths << root.join("app", "javascript")
      # host’s JS:
      app.config.assets.paths << app.root.join("app", "javascript")
    end

    # Precompile engine assets (CSS & JS)
    initializer "open_fresk.assets.precompile", after: :assets do |app|
      app.config.assets.precompile += %w[
        open_fresk/application.css
        open_fresk/application.js
        controllers/*.js
      ]
    end

    # Load core extensions
    initializer "open_fresk.core_ext.string", before: :load_config_initializers do
      config.to_prepare do
        ::String.include OpenFresk::CoreExtensions::String
      end
    end

    # Make engine views available to host app controllers
    initializer "open_fresk.append_view_paths", after: :load_config_initializers do
      ActiveSupport.on_load(:action_controller) do
        append_view_path OpenFresk::Engine.root.join("app/views")
      end
    end

    # Include shared helpers after load
    config.to_prepare do
      ::ApplicationController.helper(::HeaderHelper)
      ::ApplicationController.helper(::PlateformAccess::RightsHelper)

      ::ApplicationController.helper(FontAwesome5::Rails::IconHelper)
      OpenFresk::ApplicationController.helper(FontAwesome5::Rails::IconHelper)
    end

    # Pin importmap entries for engine
    initializer "open_fresk.importmap", after: "importmap.setup" do |app|
      app.config.importmap.draw do
        pin "open_fresk/application", to: asset_path("open_fresk/application.js"), preload: true
        pin_all_from "#{root}/app/javascript/open_fresk/controllers", under: "controllers"
      end
    end
  end
end