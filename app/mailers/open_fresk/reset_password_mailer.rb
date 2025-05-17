module OpenFresk
  class ResetPasswordMailer < ApplicationMailer
    def reset_password(user:, reset_url:, forgot_password_url:, subject:)
      @user = user
      @reset_url = reset_url
      @forgot_password_url = forgot_password_url
      @subject = subject
      mail(to: user.email, subject: @subject)
    end
  end  
end