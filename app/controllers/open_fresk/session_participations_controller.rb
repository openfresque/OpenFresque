module OpenFresk
  class SessionParticipationsController < ApplicationController
    include SimpleCommand

    before_action :set_training_session, only: %i[show facilitator_registration]
    before_action :set_participations, only: %i[show]

    def show
      @training_session = @training_session.decorate
    end

    def facilitator_registration
      command = ::Participations::FacilitatorParticipation.new(
        training_session: @training_session,
        current_user:,
        param_animation: params[:animation]
      )

      if command.call.nil? || command.errors.any?
        flash[:alert] = command.errors.full_messages.to_sentence
      else
        flash[:notice] = I18n.t('training_sessions.animator_registered')
      end
      redirect_to session_participation_path(@training_session)
    end

    private

    def set_training_session
      @training_session = ::TrainingSession.find(params[:id])
      redirect_to root_path, notice: t('training_sessions.not_found') if @training_session.nil?
    end

    def set_participations
      @participations = @training_session.participations
      @present_participations = @participations.where(facilitator_role: nil).confirmed
      @facilitator_participations = @training_session.participations.where(facilitator_role: [Participation::Facilitator])
    end
  end
end
