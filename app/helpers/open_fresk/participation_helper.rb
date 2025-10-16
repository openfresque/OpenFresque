module OpenFresk
  module ParticipationHelper
    # include InvitationHelper
    # include TrainingSessions::TrainingSessionRegisterAnimatorHelper
    # include Participations::AnonymousParticipantsHelper

    def participants_emails(participations)
      participations.where.not(status: Participation::Declined).map(&:user).map(&:email).join(';')
    end

    def animators_emails(session)
      session.participations.animator.map(&:user).map(&:email).join(';')
    end

    def participant_name(participation)
      participation.user&.fullname
    end

    def user_email_link_or_text(participation)
      if current_user_is_admin?
        link_to(participation.user&.email, user_path(participation.user))
      else
        participation.user&.email
      end
    end
  end
end
