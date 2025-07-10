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
        redirect_to request.original_url.gsub("language=#{language}", 'language=en')
      end
    end
  end
end
