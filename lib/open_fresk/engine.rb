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

    # Precompile engine assets
    initializer "open_fresk.assets.precompile" do |app|
      app.config.assets.precompile += %w[ open_fresk/application.css ]
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
      # Engine and host controllers share these
      ::ApplicationController.helper(::HeaderHelper)
      ::ApplicationController.helper(::PlateformAccess::RightsHelper)

      # FontAwesome icon helper
      ::ApplicationController.helper(FontAwesome5::Rails::IconHelper)
      OpenFresk::ApplicationController.helper(FontAwesome5::Rails::IconHelper)
    end
  end
end
