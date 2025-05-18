# config/initializers/open_fresk_smtp.rb

Rails.application.config.to_prepare do
  # Ensure this runs after the models are loaded and the database connection is available.
  # The to_prepare block is suitable for this during development (reloads on each request)
  # and for production (runs once during initialization).

  begin
    # Check if the SmtpSetting table exists to prevent errors during initial setup/migrations
    if ActiveRecord::Base.connection.table_exists? 'open_fresk_smtp_settings'
      smtp_setting = OpenFresk::SmtpSetting.current

      if smtp_setting
        ActionMailer::Base.smtp_settings = {
          address:              smtp_setting.host,
          port:                 smtp_setting.port,
          user_name:            smtp_setting.username,
          password:             smtp_setting.password,
          authentication:       :plain, # Or :login, :cram_md5, depending on your server
          enable_starttls_auto: true    # Or false, depending on your server
          # You might need other settings like :domain, :openssl_verify_mode etc.
        }
      else
        Rails.logger.warn "OpenFresk: SMTP settings not found in database. Mail delivery might fail."
      end
    else
      Rails.logger.info "OpenFresk: open_fresk_smtp_settings table does not exist yet. Skipping SMTP configuration."
    end
  rescue ActiveRecord::NoDatabaseError
    Rails.logger.info "OpenFresk: No database connection yet. Skipping SMTP configuration."
  rescue PG::ConnectionBad, ActiveRecord::StatementInvalid => e # Catch connection or uninitialized table errors
    Rails.logger.warn "OpenFresk: Database not ready or SmtpSetting table issue during SMTP initialization: #{e.message}. Skipping SMTP configuration."
  rescue => e
    Rails.logger.error "OpenFresk: Error loading SMTP settings: #{e.message}"
    # Optionally, re-raise if this is critical and should halt initialization
    # raise e
  end
end 