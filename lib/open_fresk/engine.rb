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
      config.autoload_paths = config.autoload_paths + [root.join("app", "classes")]
      config.eager_load_paths = config.eager_load_paths + [root.join("app", "classes")]
    end

    initializer "open_fresk.assets.precompile" do |app|
      app.config.assets.precompile += %w( open_fresk/application.css )
    end
  end
end
