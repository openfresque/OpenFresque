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

    initializer "open_fresk.add_autoload_paths", before: :set_autoload_paths do |app|
      # Reassign autoload and eager load paths rather than mutating a frozen array.
      config.autoload_paths = config.autoload_paths + [root.join("app", "services")]
      config.eager_load_paths = config.eager_load_paths + [root.join("app", "services")]
    end

    initializer "open_fresk.assets.precompile" do |app|
      app.config.assets.precompile += %w( open_fresk/application.css )
    end

    # Load core_extensions before the application initializes
    initializer "open_fresk.core_ext.string", before: :load_config_initializers do
      config.to_prepare do
        ::String.include OpenFresk::CoreExtensions::String
      end
    end
  end
end
