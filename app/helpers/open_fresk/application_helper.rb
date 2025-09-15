module OpenFresk
  module ApplicationHelper
    def current_language
      if I18n.locale == :en
        'English'
      elsif I18n.locale == :fr
        'Français'
      end
    end

    def language_name(locale)
      case locale
      when 'en'
        'English'
      when 'fr'
        'Français'
      when 'es'
        'Español'
      end
    end
  end
end
