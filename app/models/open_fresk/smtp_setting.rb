module OpenFresk
  class SmtpSetting < ApplicationRecord
    validates :host, presence: true
    validates :port, presence: true, numericality: { only_integer: true, greater_than: 0 }
    validates :username, presence: true
    # We'll encrypt the password later if needed, for now, presence validation is enough.
    validates :password, presence: true

    # Ensure only one record exists
    validate :ensure_singleton, on: :create

    def self.current
      # Create a default record if none exists
      first || create_default_setting
    end

    private

    def ensure_singleton
      if SmtpSetting.exists?
        errors.add(:base, "Only one SMTP setting record is allowed.")
      end
    end

    def self.create_default_setting
      # You might want to customize these default values or load them from ENV vars initially
      # For now, using placeholders.
      create(
        host: "smtp.example.com",
        port: 587,
        username: "user",
        password: "password" # Consider using Rails credentials or another secure way for defaults
      )
    rescue ActiveRecord::RecordInvalid
      # This can happen if another request created the record in the meantime.
      # In that case, just fetch the existing one.
      first
    end
  end
end
