module OpenFresk
  class ForgotPasswordsController < ApplicationController
    skip_before_action :authenticate_user!

    def new
    end

    def create
      user = ::User.where(email: params[:email]&.downcase).first
      if user.nil?
        redirect_to open_fresk.new_session_path(language: language(user)), notice: t("sessions.forgot_password_user_unknown")
      else
        ResetPasswordJob.perform_later(user.id, Tenant.current.id)
        redirect_to open_fresk.new_session_path(language: language(user)), notice: t("sessions.forgot_password_email_sent")
      end
    end
  end

  def user_language(user)
    "en"
  end
end