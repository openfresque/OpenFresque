module Participations
  class CreateParticipation
    prepend SimpleCommand

    def initialize(participation_params:, current_user:, training_session:, participation_status:, animator: nil)
      @participation_params = participation_params
      @current_user = current_user
      @training_session = training_session
      @participation_status = participation_status
      @animator = animator || User.find(training_session.created_by_user_id) # TODO: Discuss this hack with bastien
    end

    def call
      command = Users::CreateUser.new(
        user_params: create_user_params,
        country_params: participation_params,
        current_user: current_user,
        language: @training_session.language&.code
      )

      if find_user.present?
        @user = find_user
      else
        @user = command.call
      end

      participation = find_participation || Participation.new

      return errors.add(:base, @user.errors.full_messages.to_sentence) if @user.errors.any?

      participation.training_session = @training_session
      participation.user = @user
      participation.status = participation_status
      participation.animator = @animator
      participation.save

      participation
    end

    private

    attr_reader :participation_params, :current_user, :training_session, :participation_status

    def create_user_params
      {
        firstname: participation_params[:first_name],
        lastname: participation_params[:last_name],
        email: participation_params[:email].strip.downcase,
        #country_id: participation_params[:country_id],
        #cgu: participation_params[:cgu],
        password: SecureRandom.hex(8) + "A!",
        # invoicing_company_name: participation_params[:invoicing_company_name],
        # invoicing_firstname: participation_params[:invoicing_firstname],
        # invoicing_lastname: participation_params[:invoicing_lastname],
        # invoicing_street: participation_params[:invoicing_street],
        # invoicing_zip: participation_params[:invoicing_zip],
        # invoicing_city: participation_params[:invoicing_city]
      }
    end

    def find_user
      User.find_by(email: participation_params[:email])
    end

    def find_participation
      @user.participations.find_by(user_id: @user.id, training_session: @training_session.id)
    end

    def archived_user_update
      @user.email = participation_params[:email]
      @user.firstname = participation_params[:first_name]
      @user.lastname = participation_params[:last_name]
      @user.country_id = participation_params[:country_id]
      @user.password = SecureRandom.hex(8) + "A!"
      @user.token = SecureRandom.uuid
      @user.refresh_token = SecureRandom.uuid
      @user.time_zone = @training_session.time_zone
      @user.cgu = Time.current
      @user.isArchived = false
      @user.invoicing_company_name = participation_params[:invoicing_company_name]
      @user.invoicing_firstname = participation_params[:invoicing_firstname]
      @user.invoicing_lastname = participation_params[:invoicing_lastname]
      @user.invoicing_street = participation_params[:invoicing_street]
      @user.invoicing_zip = participation_params[:invoicing_zip]
      @user.invoicing_city = participation_params[:invoicing_city]
      @user.save
    end

    def user_update
      return unless @user.last_sign_in_at.nil?

      @user.update!(
        firstname: participation_params[:first_name]&.downcase,
        lastname: participation_params[:last_name]&.downcase,
        country_id: participation_params[:country_id],
        invoicing_company_name: participation_params[:invoicing_company_name],
        invoicing_firstname: participation_params[:invoicing_firstname],
        invoicing_lastname: participation_params[:invoicing_lastname],
        invoicing_street: participation_params[:invoicing_street],
        invoicing_zip: participation_params[:invoicing_zip],
        invoicing_city: participation_params[:invoicing_city]
      )
    end

    def params
      {
        country: {
          country_id: participation_params[:country_id]
        }
      }
    end
  end
end
