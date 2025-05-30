module OpenFresk
  module TrainingSessions
    module TrainingSessionLanguageHelper
      def training_session_language(session)
        icon = fa_icon("globe")
        text = t("languages.#{session&.language&.iso3}")
        content_tag(:div, "#{icon} #{text}".html_safe)
      end
    end
  end
end
