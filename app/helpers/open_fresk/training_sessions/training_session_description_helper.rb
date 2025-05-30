module OpenFresk
  module TrainingSessions
    module TrainingSessionDescriptionHelper
      def training_session_title(session)
        return
      end

      def training_session_description(session)
        title = t("training_sessions.description")
        text = training_session_description_text(session)
        content_tag(:div, class: "mt-3") do
          concat(content_tag(:div, title, class: "h6 fw-bold"))
          concat(text)
        end
      end

      def training_session_description_text(session)
        if session.description.blank?
          t("training_sessions.no_description")
        else
          session.description
        end
      end
    end
  end
end