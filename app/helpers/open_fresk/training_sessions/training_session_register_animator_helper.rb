module OpenFresk
  module TrainingSessions
    module TrainingSessionRegisterAnimatorHelper
      def can_register_as_observer?(session, user)
        return false if already_registered_participants?(session, user)

        creator_id = session.created_by_user_id
        if session.formation?
          (session.observer_role_open? && (!user.white? && !user.yellow?)) ||
            (user.id == creator_id && (!user.white? && !user.yellow?)) ||
            session.observer?(user)
        else
          session.observer_role_open? || (user.id == creator_id && user.animator?) ||
            session.observer?(user)
        end
      end

      def can_register_as_coanimator?(session, user)
        return false if already_registered_participants?(session, user)

        creator_id = session.created_by_user_id
        if session.formation?
          (session.coanimator_role_open? && (!user.white? && !user.yellow?)) ||
            (user.id == creator_id && (!user.white? && !user.yellow?)) ||
            session.coanimator?(user)
        else
          session.coanimator_role_open? || (user.id == creator_id && user.animator?) ||
            session.coanimator?(user)
        end
      end

      def can_register_as_animator?(session, user)
        return false if already_registered_participants?(session, user)

        creator_id = session.created_by_user_id
        if session.formation?
          (session.animator_role_open? && (!user.white? && !user.yellow? && !user.orange?)) ||
            (user.id == creator_id && (!user.white? && !user.yellow? && !user.orange?)) ||
            session.animator?(user)
        else
          session.animator_role_open? || (user.id == creator_id && user.animator?) ||
            session.animator?(user)
        end
      end

      def can_register_as_coach?(session, user)
        return false if already_registered_participants?(session, user) || session.formation?

        creator_id = session.created_by_user_id
        session.coach_role_open? || session.coach?(user) || (user.id == creator_id && user.animator?)
      end

      def already_registered_participants?(session, user)
        !my_present_participants_count(session, user).zero?
      end
    end
  end
end