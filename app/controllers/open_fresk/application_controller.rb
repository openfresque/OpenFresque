module OpenFresk
  class ApplicationController < ::ApplicationController
    include OpenFresk::Authentication

    before_action :set_unsigned_language

    def language
      params[:language]
    end

    def set_unsigned_language
      return unless language

      if %w[fr en].include?(language)
        I18n.locale = language
      elsif language.include?('\u0026')
        redirect_to request.original_url.gsub('\\u0026', '&')
      else
        redirect_to request.original_url.gsub('language=en')
      end
    end

    def set_signed_language
      return unless current_user

      if language && (current_user.native_language.nil? || current_user.native_language != language)
        current_user.update(native_language: language)
      end

      I18n.locale = current_user.native_language
    end
  end
end
