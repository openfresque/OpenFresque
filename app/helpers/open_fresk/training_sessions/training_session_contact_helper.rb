module OpenFresk
  module TrainingSessions
    module TrainingSessionContactHelper
      def training_session_contact(session)
        name = training_session_contact_name(session)
        email = training_session_contact_email(session)

        content_tag(:div, class: "my-3") do
          concat(content_tag(:span, t("training_sessions.contact"), class: "h6 fw-bold"))
          concat(content_tag(:div, "#{fa_icon('user')} #{name}".html_safe))
          concat(content_tag(:div, "#{fa_icon('envelope')} #{email}".html_safe))
        end
      end

      def training_session_contact_email(session)
        session.created_by_user&.email
      end

      def training_session_contact_name(session)
        session.created_by_user&.fullname
      end
    end
  end
end