if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }

    database_url = ENV['DATABASE_URL']
    if database_url
      ENV['DATABASE_URL'] = "#{database_url}?pool=25"
      ActiveRecord::Base.establish_connection
    end
  end

  Sidekiq.configure_client do |config|
    config.redis = { ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
  end
else
  # Window configuration (Redis under WSL)
  if Gem.win_platform?
    puts "🔴 Windows detected: Redis configuration for Sidekiq"

    Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
    end

    Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://localhost:6379/0' }
    end
  end
end