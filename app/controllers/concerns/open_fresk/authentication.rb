module OpenFresk::Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
    before_action  :authenticate_user!
  end

  def current_user
    @current_user ||= ::User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    return if current_user
    session[:forwarding_url] = request.fullpath if request.get?
    redirect_to new_session_path, alert: t("please_log_in")
  end
end