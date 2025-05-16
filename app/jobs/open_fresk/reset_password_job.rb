class ResetPasswordJob < ApplicationJob
  include Rails.application.routes.url_helpers
  sidekiq_options queue: :critical

  def perform(user_id, tenant_id)
    user = User.find(user_id)
    
    reset_password_token ||= SecureRandom.uuid
    $redis.set("fresqueclimat:users:reset_password_token:#{reset_password_token}", user.id, ex: 2 * 24 * 3600)

    I18n.locale = Languages::SetEmailLanguage.new(language: user.native_language).call

    reset_url = new_recover_password_url(ho st: ENV["HOST"], subdomain: user.tenant.subdomain,
                                          recovery_token: reset_password_token)
    forgot_password_url = new_forgot_password_url(host: ENV["HOST"], subdomain: user.tenant.subdomain)

    subject = I18n.t("reset_password.subject")

    ResetPasswordMailer.reset_password(user:, reset_url:, forgot_password_url:, subject:).deliver_now
  end
end
