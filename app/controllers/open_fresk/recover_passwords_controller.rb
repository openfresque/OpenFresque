module OpenFresk
  class RecoverPasswordsController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :set_recovery_token
    before_action :set_current_user
    before_action :verify_token
  
    def new
    end
  
    def create
      if @current_user.update(
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      )
        redirect_to root_path(language: params[:language]), notice: t("success")
      else
        @errors = @current_user.errors
        render :new
      end
    end
  
    private
  
    def set_current_user
      @current_user = User.find_by(id: user_id_from_reset_token)
    end
  
    def user_id_from_reset_token
      $redis.get("openfresk:users:reset_password_token:#{@recovery_token}")
    end
  
    def verify_token
      redirect_to open_fresk.new_forgot_password_path, alert: t("password_recovery_invalid") unless @current_user
      nil
    end
  
    def set_recovery_token
      @recovery_token = params[:recovery_token]
    end
  end  
end