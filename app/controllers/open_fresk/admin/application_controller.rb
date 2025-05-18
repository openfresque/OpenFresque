require "administrate"

# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module OpenFresk
  module Admin
    class ApplicationController < ::Administrate::ApplicationController
      # before_action :authenticate_admin # You'll need to implement this

      # def authenticate_admin
      #   # TODO Add authentication logic here.
      #   # For example, using Devise:
      #   # redirect_to '/', alert: 'Not authorized.' unless current_user && current_user.admin?
      # end

      # Override this value to specify the number of elements to display at a time
      # on index pages. Defaults to 20.
      # def records_per_page
      #   params[:per_page] || 20
      # end

      # Override Administrate's resource_class to correctly find engine models
      def resource_class
        # controller_name will be e.g. "users", "training_sessions"
        model_name = controller_name.singularize.camelize
        "OpenFresk::#{model_name}".constantize
      end

      # dashboard_class method to locate dashboards within the engine
      def dashboard_class
        # resource_class is expected to be e.g., OpenFresk::User
        # Dashboard class is expected to be e.g., OpenFresk::UserDashboard
        klass_name = "#{resource_class.name}Dashboard"
        klass_name.constantize
      end

      def find_dashboard
        dashboard_class.new
      end

      # Defines the dashboard manifest for Administrate sidebar within the engine.
      def dashboard_manifest
        [
          OpenFresk::User, 
          OpenFresk::SmtpSetting,
          OpenFresk::TrainingSession,
          # Add other dashboards from this engine here
        ]
      end
    end
  end
end 