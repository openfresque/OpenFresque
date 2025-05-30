module OpenFresk
  class SessionParticipationsController < ApplicationController
    before_action :set_training_session, only: %i[show]
    def show
      @training_session = @training_session.decorate
    end

    private

      def set_training_session
        @training_session = ::TrainingSession.find(params[:training_session_id] || params[:id])
        redirect_to root_path, notice: t("training_sessions.not_found") if @training_session.nil?
      end
  end
end