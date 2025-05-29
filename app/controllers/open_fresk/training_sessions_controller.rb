module OpenFresk
  class TrainingSessionsController < ApplicationController
    before_action :set_training_session,
                  only: %i[edit update]
    def index
      public_opportunities
    end

    def new
      @training_session = TrainingSession.new
    end

    def edit
      def edit
        @facilitation_language = @training_session.language_id
        @start_time = @training_session.local_start_time.strftime("%H:%M")
        @end_time = @training_session.local_end_time.strftime("%H:%M")
      end
    end

    def update
      command = TrainingSessions::UpdateTrainingSession.new(
        training_session_params: training_session_params,
        training_session: @training_session,
        current_user: current_user,
        recurrent: params[:recurrent],
        contact: params.dig(:contact),
        context: params.dig(:context)
      )
      command.call

      if @training_session.errors.blank?
        redirect_to training_sessions_path, notice: t("training_sessions.updated")
      else
        render :edit
      end
    end

    def create
      command = ::TrainingSessions::CreateTrainingSession.new(
        training_session_params: training_session_params,
        current_user: current_user,
        contact: params.dig(:contact),
        past: params.dig(:past),
        context: params.dig(:context)
      )
      @training_session = command.call

      if @training_session.errors.blank?
        redirect_to training_sessions_path,
                    notice: t("training_sessions.created")
      else
        render :new
      end
    end

    private
      def training_session_params
        params
        .require(:training_session)
        .permit(
          :description,
          :language_id,
          :country_id,
          :date,
          :start_hour,
          :end_hour,
          :category,
          :format,
          :connexion_url,
          :room,
          :street,
          :city,
          :zip,
          :country,
          :capacity,
          :public,
          :session_info,
          :latitude,
          :longitude
        )
      end

      def sessions_lists
        public_opportunities
      end

      def public_opportunities
        training_sessions = TrainingSession.futur
        @my_training_sessions = training_sessions.my_sessions(current_user)
      end

      def set_training_session
        @training_session = TrainingSession.find(params[:id])
      end
  end
end