module Users
  class CreateUser
    include SimpleCommand

    def initialize(user_params:, country_params:, current_user:, language: nil)
      @user_params = user_params
      @country_params = country_params
      @current_user = current_user
      @language = language
    end

    def call
      @user = User.new(user_params)
      @user.token = SecureRandom.uuid
      @user.refresh_token = SecureRandom.uuid
      #@user.country_id = country_params[:country_id].to_i
      @user.save

      return @user if @user.errors.present?

      @user
    end

    private

    attr_reader :user_params, :country_params, :current_user, :language
  end
end
