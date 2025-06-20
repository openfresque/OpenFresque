module Languages
  class SetLanguage
    def initialize(params, user = nil)
      @params = params
      @user = user
    end

    def call
      # if !@user.nil?
      #   @user.native_language
      # else
      #   @params[:language].present? ? @params[:language] : "en"
      # end
      "fr"
    end

    private

    attr_reader :params, :user
  end
end
