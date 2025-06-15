module Transactions
  class TransactionManager
    include SimpleCommand

    def initialize(product_params:, participation_params:, training_session:, billing_params:, language:)
      @product_params = product_params
      @participation_params = participation_params
      @training_session = training_session
      @language = language
      @billing_params = billing_params
      @organisation_params = build_organisation_params if @billing_params&.dig(:organisation).present?
      @contact_params = build_contact_params
    end

    def call
      ActiveRecord::Base.transaction do
        product_configuration = ProductConfiguration.find(product_params[:product_configuration_id])

        participation_command = Participations::CreateParticipation.new(
          participation_params:,
          current_user: nil,
          training_session:,
          participation_status: Participation::WaitingForPayment
        )

        @participation = participation_command.call
        unless @participation.success?
          errors.add_multiple_errors(@participation.errors)
          return @participation
        end

        transaction_command = Transactions::CreateTransaction.new(
          participation: @participation.result,
          product_configuration:,
          custom_price: product_params[:custom_price],
          coupon_code: product_params[:coupon_code]
        )
        @transaction = transaction_command.call

        if transaction_command.errors.present?
          errors.add_multiple_errors(transaction_command.errors)
          return @participation
        end

        if product_configuration&.product&.charged?
          Transactions::CreateBillingInfo.call(
            transaction: @transaction,
            organisation_params: @organisation_params,
            contact_params: @contact_params
          )
        end

        @participation
      rescue ActiveRecord::RecordInvalid => e
        errors.add(:base, e.record.errors.full_messages.to_sentence)
        raise ActiveRecord::Rollback
      end
    end

    attr_reader :product_params,
                :participation_params,
                :training_session,
                :transaction

    private

    def build_contact_params
      contact_params = @billing_params&.dig(:contact)&.compact_blank
      return unless contact_params.present?

      contact_params.merge({country_id: participation_params[:country_id]})
    end

    def build_organisation_params
      organisation_params = @billing_params[:organisation].compact_blank
      return unless organisation_params.present?

      organisation_params.merge({
                                  address: participation_params[:invoicing_street],
                                  zip_code: participation_params[:invoicing_zip],
                                  city: participation_params[:invoicing_city],
                                  country_id: participation_params[:country_id]
                                })
    end
  end
end
