module OpenFresk
  module Admin
    class SmtpSettingsController < OpenFresk::Admin::ApplicationController
      # To customize the behavior of this controller,
      # you can overwrite any of the RESTful actions.
      #
      # Define a custom finder by overriding the `find_resource` method:
      def find_resource(param)
        OpenFresk::SmtpSetting.current
      end

      # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
      # for more information

      # Only show, edit, update actions are appropriate for a singleton.
      # Index will redirect to show.
      def index
        # Assuming SmtpSetting.current either exists or creates a default one.
        # The ID is passed for explicit resource identification in the URL, though find_resource ignores it.
        redirect_to action: :show, id: OpenFresk::SmtpSetting.current.id
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "SMTP settings not found. A default record should have been created."
        redirect_to open_fresk.admin_root_path # Or a more generic admin path
      end

      def show
        @resource = OpenFresk::SmtpSetting.current
        render :show, locals: { page: Administrate::Page::Show.new(dashboard, @resource) }
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "SMTP settings not found. A default record should have been created."
        redirect_to open_fresk.admin_root_path
      end

      def edit
        @resource = OpenFresk::SmtpSetting.current
        render :edit, locals: { page: Administrate::Page::Form.new(dashboard, @resource) }
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "SMTP settings not found. A default record should have been created."
        redirect_to open_fresk.admin_root_path
      end

      def update
        @resource = OpenFresk::SmtpSetting.current
        if @resource.update(resource_params)
          redirect_to(
            [namespace, @resource], # `namespace` should resolve correctly via Administrate
            notice: translate_with_resource("update.success"),
          )
        else
          render :edit, locals: {
            page: Administrate::Page::Form.new(dashboard, @resource),
          }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "SMTP settings not found. Cannot update."
        redirect_to open_fresk.admin_root_path
      end

      # Disable unwanted actions for a singleton resource
      def new
        not_found
      end

      def create
        not_found
      end

      def destroy
        not_found
      end

      private

      def resource_params
        # Use the model_name.param_key for robustness with namespaced models
        params.require(OpenFresk::SmtpSetting.model_name.param_key).permit(*dashboard.permitted_attributes)
      end

      def dashboard
        @dashboard ||= OpenFresk::SmtpSettingDashboard.new
      end

      # Override `requested_resource` to always use SmtpSetting.current for most actions
      # that rely on it implicitly through `find_resource`.
      # However, for a singleton, `find_resource` is generally sufficient.
      # def requested_resource
      # OpenFresk::SmtpSetting.current
      # end 

      def not_found
        raise ActionController::RoutingError, 'Not Found'
      end
    end
  end
end 