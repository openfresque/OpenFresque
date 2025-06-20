module Languages
  class SetEmailLanguage
    def initialize(language:)
      @language = language
    end

    def call
      #Constants::Locales::LIST.include?(@language) ? @language : "en"
      "fr"
    end

    private

    attr_reader :language
  end
end
