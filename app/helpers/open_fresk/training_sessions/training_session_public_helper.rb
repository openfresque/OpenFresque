module OpenFresk
  module TrainingSessions
    module TrainingSessionPublicHelper
      def training_session_public(session)
        icon = fa_icon("users")
        text = training_session_public_text(session)
        content_tag(:div, "#{icon} #{text}".html_safe)
      end

      def training_session_public_text(session)
        text = if session.public
          "#{t('training_sessions.public_session')}
        #{t('training_sessions.public_text')}"
        else
          "#{t('training_sessions.private_session')}
          #{t('training_sessions.private_text')}"
        end
        content_tag(:span, text.html_safe)
      end
    end
  end
end