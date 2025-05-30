module OpenFresk
  module TrainingSessions
    module TrainingSessionRecurrenceHelper
      def training_session_recurrence(session)
        return unless current_user.super_admin? || current_user.administrator? || session.organisator?(current_user)

        style = session.group_id.nil? ? "secondary" : "main"
        icon = fa_icon("redo")
        text = session.group_id.nil? ? t("add_recurrences") : t("recurring")
        content_tag(:a, href: new_recurrence_training_session_path(session.uuid), class: "link-#{style}") do
          content_tag(:span, icon.html_safe, class: "text-decoration-none") +
            content_tag(:span, text.html_safe, class: "text-decoration-none ms-1")
        end
      end
    end
  end
end