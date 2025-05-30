module OpenFresk
  module TrainingSessions
    module TrainingSessionCardHelper
      def bottom_card_counter_style(session, user)
        if session.animator_or_coanimator?(user) && my_present_participants_count(session, user) > 0
          "me-2 alert alert-primary p-1 text-small text-primary %>"
        elsif session.animator_or_coanimator?(user) && my_present_participants_count(session, user).zero?
          "me-2 alert alert-warning p-1 text-small text-warning %>"
        else
          "me-2 alert alert-secondary p-1 text-small text-secondary %>"
        end
      end

      def bottom_card_counter_number(session, user)
        if session.animator_or_coanimator?(user)
          my_present_participants_count(session, user)
        else
          0
        end
      end

      def bottom_card_counter_sentence(session, user)
        if session.animator_or_coanimator?(user) && my_present_participants_count(session, user).zero?
          t("training_sessions.card.no_count")
        else
          ""
        end
      end
    end
  end
end
