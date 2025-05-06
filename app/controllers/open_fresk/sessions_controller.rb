module OpenFresk
  class SessionsController < ApplicationController
    def new
    end

    def create
      user = ::User.where(email: params[:email]&.downcase).first
      if user&.authenticate(params[:password])
        session[:user_id] = user.id

        # Allow host app to add custom behavior
        after_sign_in_hook(user)

        redirect_to redirection_url(user)
      else
        @alert = t("sessions.invalid_credentials")
        respond_to do |format|
          format.html { redirect_to open_fresk.new_session_path, alert: @alert }
          format.turbo_stream do
            render turbo_stream: turbo_stream.prepend("signin", partial: "wrong_credentials", locals: {alert: @alert})
          end
        end
      end
    end

    private

      def redirection_url(user)
        root_url
      end

      def after_sign_in_hook(user)
        # No-op by default
      end
  end
end