require "sprockets/rails"
require "font_awesome5_rails"
require "administrate"

module OpenFresk
  class Engine < ::Rails::Engine
    isolate_namespace OpenFresk

    config.before_initialize do
      # Add dependent gems asset paths to the application's asset pipeline
      # This ensures that sprockets (and subsequently SassC via sprockets-rails)
      # can find assets from these gems.

      # Bootstrap assets
      if bootstrap_spec = Gem.loaded_specs["bootstrap"]
        config.assets.paths << File.join(bootstrap_spec.full_gem_path, "assets", "stylesheets")
        # Add other bootstrap asset types if needed (e.g., javascripts, fonts)
      end

      # Administrate assets
      # if administrate_spec = Gem.loaded_specs["administrate"]
      #   config.assets.paths << File.join(administrate_spec.full_gem_path, "app", "assets", "stylesheets")
      #   config.assets.paths << File.join(administrate_spec.full_gem_path, "app", "assets", "javascripts")
      #   config.assets.paths << File.join(administrate_spec.full_gem_path, "vendor", "assets", "images") # Administrate has images here
      #   config.assets.paths << File.join(administrate_spec.full_gem_path, "vendor", "assets", "javascripts") # and some JS here
      # end
    end

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

      # Dashboards
      dashboards_path = root.join("app", "dashboards")
      config.autoload_paths   += [dashboards_path]
      config.eager_load_paths += [dashboards_path]
    end

    # Make app/javascript discoverable by Sprockets (so importmap assets are served)
    initializer "open_fresk.assets.paths", group: :all do |app|
      app.config.assets.paths << root.join("app/javascript")
    end

    # Precompile our JS entrypoint so it shows up under /assets/open_fresk.js
    initializer "open_fresk.assets.precompile", group: :all do |app|
      app.config.assets.precompile += %w[
        open_fresk/application.css
        open_fresk.js
        open_fresk/favicon.png
        manifest.json
        open_fresk/application.js
        open_fresk/logos/logo.png
      ]
    end

    # Precompile each controller under app/javascript/open_fresk/controllers
    initializer "open_fresk.assets.precompile_controllers", group: :all do |app|
      Dir[root.join("app/javascript/open_fresk/controllers/*.js")].each do |full_path|
        logical_path = Pathname.new(full_path).relative_path_from(root.join("app/javascript")).to_s
        app.config.assets.precompile << logical_path
      end
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

    # # Tell importmap-rails about our engine's own importmap.rb
    initializer "open_fresk.importmap", after: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
    end

    # Include shared helpers after load
    config.to_prepare do
      # Engine and host controllers share these
      #::ApplicationController.helper(::HeaderHelper)
      #::ApplicationController.helper(::PlateformAccess::RightsHelper)

      ::ApplicationController.helper :all
      OpenFresk::ApplicationController.helper :all

      # FontAwesome icon helper
      ::ApplicationController.helper(FontAwesome5::Rails::IconHelper)
      OpenFresk::ApplicationController.helper(FontAwesome5::Rails::IconHelper)
    end
  end
end