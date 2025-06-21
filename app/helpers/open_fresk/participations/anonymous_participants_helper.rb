module OpenFresk
  module Participations
    module AnonymousParticipantsHelper
      def anonymous_participants?(session)
        #Tenant.current.anonymous_participants? && session.atelier?
        false
      end

      def my_anonymous_participants_count(session, animator)
        #session.facilitator_participation(animator)&.anonymous_count.to_i
        0
      end

      def max_anonymous(session)
        Constants::Participations::MAX_ANONYMOUS_PARTICIPATION - my_present_participants_count(session, current_user)
      end

      def max_anonymous?(session)
        max_anonymous(session) <= 0
      end
    end
  end
end