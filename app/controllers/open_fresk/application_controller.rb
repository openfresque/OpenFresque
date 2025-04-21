module OpenFresk
  class ApplicationController < ActionController::Base
    helper_method :current_user
    def current_user
      @current_user ||= User.where(id: session[:user_id]).first
    end

  end
end
