module OpenFresk
  module TrainingSessions
    module TrainingSessionLocationHelper
      def training_session_location(session)
        if session.online?
          training_session_online(session)
        else
          training_session_onsite(session)
        end
      end

      def training_session_online(session)
        icon = fa_icon("video", class: "text-secondary")
        text = if session.facilitator?(current_user) || session.observer?(current_user)
          link = link_to(t("training_sessions.visio_link"), @training_session.connexion_url,
                         class: "link-secondary text-decoration-none", target: :_blank)
          copy_btn = button_tag fa_icon("copy", type: :regular, text: t("copy")),
                                data: {text: @training_session.connexion_url}, class: "toast_btn btn p-0 copy-to-clipboard link-secondary"
          content_tag :span, "(#{link} - #{copy_btn})".html_safe, class: "link-secondary"
        end
        content_tag(:div, "#{icon} #{t('training_sessions.online')} #{text}".html_safe)
      end

      def training_session_onsite(session)
        icon = fa_icon("map-pin", class: "text-secondary")
        text = if session.room.blank? && session.street.blank?
          "#{session.city}, #{session.country.name}"
        elsif session.room.blank?
          session.street.to_s
        else
          "#{session.room}, #{session.street}"
        end
        content_tag(:div, "#{icon} #{text}".html_safe)
      end
    end
  end

end