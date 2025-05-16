module OpenFresk
  class ResetPasswordJob < ApplicationJob
    include Rails.application.routes.url_helpers
    queue_as :critical
  
    def perform(user_id)
      user = User.find(user_id)
      
      reset_password_token ||= SecureRandom.uuid
      $redis.set("openfresk:users:reset_password_token:#{reset_password_token}", user.id, ex: 2 * 24 * 3600)
  
      # TODO: Uncomment this when we develop the language switching feature
      #I18n.locale = Languages::SetEmailLanguage.new(language: user.native_language).call
  
      reset_url = OpenFresk::Engine.routes.url_helpers.new_recover_password_url(host: ENV["HOST"],
                                            recovery_token: reset_password_token)
      forgot_password_url = OpenFresk::Engine.routes.url_helpers.new_forgot_password_url(host: ENV["HOST"])
  
      subject = I18n.t("reset_password.subject")
  
      ResetPasswordMailer.reset_password(user:, reset_url:, forgot_password_url:, subject:).deliver_now
    end
  end  
end