module OpenFresk
  module TrainingSessionStaffingHelper
    # Session participants full badge
    def participant_capacity_full_badge(session)
      return unless session.participant_capacity_full?

      content_tag(:span, class: "px-2 py-1 rounded-pill bg-warning bg-opacity-75 text-dark small") do
        t("training_sessions.participant_capacity_full")
      end
    end

    def animator_capacity_full_badge(session)
      return unless session.animation_full?

      content_tag(:span, class: "px-2 py-1 rounded-pill bg-warning bg-opacity-75 text-dark small") do
        t("training_sessions.full")
      end
    end

    def counting_role_capacity(session, role, count)
      creator_participation = session.participations.find_by(animator_id: @training_session.created_by_user_id)
      if !creator_participation.nil? && creator_participation.animator_role == role
        count + 1
      else
        count
      end
    end
  end
end