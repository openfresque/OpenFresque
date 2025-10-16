module Participations
  class FacilitatorParticipation
    include SimpleCommand

    def initialize(training_session:, current_user:, param_animation:)
      @training_session = training_session
      @current_user = current_user
      @param_animation = param_animation
    end

    def call
      find_participation
      handle_participation
    end

    private

    attr_reader :current_user, :training_session, :param_animation, :param_remuneration, :participation

    def handle_participation
      if unregistered?
        unregister_participation
      elsif @participation.nil?
        register_new_participation
      else
        update_existing_participation
      end
    end

    def unregistered?
      param_animation == 'unregistered'
    end

    def unregister_participation
      participation&.destroy!
      I18n.t('training_sessions.animator_unregistered')
    end

    def register_new_participation
      @participation = create_participation
      I18n.t('training_sessions.animator_registered')
    end

    def update_existing_participation
      participation.update(participation_attributes)
      I18n.t('training_sessions.animator_updated')
    end

    def create_participation
      Participation.create(participation_attributes)
    end

    def participation_attributes
      {
        training_session:,
        user: current_user,
        animator: current_user,
        status: Participation::Confirmed,
        facilitator_role: param_animation
      }
    end

    # def send_registration_confirmation
    #   Participations::SessionRegistrationConfirmationJob.perform_later(participation.id, Tenant.current.id)
    # end

    def find_participation
      @participation = @training_session.participations.find_by(
        training_session:,
        user: current_user,
        animator: current_user
      )
    end
  end
end
