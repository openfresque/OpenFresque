module OpenFresk
  class ApplicationController < ActionController::Base
    helper_method :current_user

    before_action :authenticate_user!
    def current_user
      @current_user ||= ::User.where(id: session[:user_id]).first
    end

    def authenticate_user!
      return unless current_user.nil?

      session[:forwarding_url] = request.original_url if request.get?
      session[:user_id] = nil
      redirect_to open_fresk.new_session_path(language: language || "fr"), status: 301
    end

  end
end
