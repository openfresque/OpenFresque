module OpenFresk
  module ApplicationHelper
    def current_language
      "Français"
    end

    def language_name(locale)
      case locale
        when "en"
          "English"
        when "fr"
          "Français"
        when "es"
          "Español"
      end
    end
  end
end
