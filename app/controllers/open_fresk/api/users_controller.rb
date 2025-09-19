module OpenFresk
  module Api
    class UsersController < BaseController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!
      before_action :set_user, only: %i[show update destroy]

      def index
        @users = User.all
        render json: @users
      end

      def show
        render json: @user
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @user.destroy
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:firstname, :lastname, :email, :password, :user_role)
      end
    end
  end
end
