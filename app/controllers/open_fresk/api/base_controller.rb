module OpenFresk
  module Api
    class BaseController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
      rescue_from StandardError, with: :internal_server_error

      private

      def not_found(error)
        render json: { error: error.message }, status: :not_found
      end

      def unprocessable_entity(error)
        render json: { error: error.record.errors.full_messages }, status: :unprocessable_entity
      end

      def internal_server_error(error)
        render json: { error: error.message }, status: :internal_server_error
      end
    end
  end
end
