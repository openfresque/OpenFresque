module Transactions
  class CreateBillingInfo
    prepend SimpleCommand

    def initialize(transaction:, contact_params:, organisation_params:)
      @transaction = transaction
      @user = @transaction.participation.user
      @contact_params = contact_params
      @organisation_params = organisation_params
    end

    def call
      find_or_create_contact if @contact_params.present?
      create_billing_info
    end

    private

    def find_or_create_contact
      return unless @contact_params[:email].present?
      return if (@contact = User.find_by_email(@contact_params[:email].strip.downcase))

      contact_command = Users::CreateUser.new(
        user_params: {
          email: @contact_params[:email].strip.downcase,
          firstname: @contact_params[:firstname],
          lastname: @contact_params[:lastname]
        },
        country_params: {country_id: @contact_params[:country_id]},
        current_user: @user,
        language: @language
      )
      @contact = contact_command.call
    end

    def create_billing_info
      BillingInfo.create!(
        contact: @contact || @user,
        user: @user,
        transaction_id: @transaction.id,
      )
    end
  end
end
