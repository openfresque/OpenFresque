module OpenFresk
  class PaymentsController < ApplicationController
    skip_before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, only: %i[create_payment_intent stripe_webhook]
    before_action :set_transaction, only: %i[new create_payment_intent]

    def new
      @language = Languages::SetLanguage.new(params, current_user).call
      @stripe_public_key = ENV["STRIPE_PUBLISHABLE_KEY"]
    end

    def create_payment_intent
      payment_intent = Stripe::PaymentIntent.create(
        amount: @transaction.after_tax_price_cents,
        currency: @transaction.currency,
        automatic_payment_methods: {
          enabled: true
        },
        metadata: {
          user_uuid: @transaction.participation.user.id,
          participation_id: @transaction.participation.id,
          training_session_uuid: @transaction.participation.training_session.id,
          invoice_number: @transaction.invoice_number,
          product_identifier: @transaction.product_configuration&.product&.identifier,
          training_session_country: @transaction.participation.training_session&.country&.name
        }
      )

      @transaction.update(payment_intent_id: payment_intent["id"], stripe_response: payment_intent)

      render json: {
        clientSecret: payment_intent["client_secret"],
        language: params[:language]
      }, status: 200
    end

    def confirmation
      raise "Missing payment intent" unless params[:payment_intent].present?

      transaction = Transaction.find_by!(payment_intent_id: params[:payment_intent])
      language = Languages::SetLanguage.new(params, current_user).call

      if params["redirect_status"] == "succeeded"
        transaction.update!(status: Transaction::Success)
        transaction.participation.update!(status: Participation::Confirmed)
        Participations::SessionRegistrationConfirmationJob.perform_later(transaction.participation.id)
        flash[:notice] = t("my_participation.confirmed", email: transaction.user.email)
        redirect_to show_public_training_session_path(transaction.training_session.id,
                                                      user_token: transaction.participation.user.token)
      else
        transaction.update!(status: Transaction::Failure)
        flash[:alert] = t("my_participation.payment_failed")
        redirect_to new_payment_path(transaction_id: transaction.id, language: language)
      end
    end

    def stripe_webhook
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      endpoint_secret = ENV["STRIPE_WEBHOOK_SECRET"]
      event = nil

      # Verify webhook signature and extract the event
      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError => e
        return render json: {error: :invalid_payload}, status: 400
      rescue Stripe::SignatureVerificationError => e
        return render json: {error: :invalid_signature}, status: 400
      end

      payment_intent = event.data.object
      transaction = Transaction.find_by(payment_intent_id: payment_intent.id)
      handle_event(event.type, transaction)

      render json: {status: 200}
    end

    private

      def set_transaction
        @transaction = Transaction.find(params[:transaction_id])
      end

      def handle_event(event_type, transaction)
        case event_type
          when "payment_intent.succeeded"
            transaction&.update(status: Transaction::Success)
          when "payment_intent.payment_failed"
            transaction&.update(status: Transaction::Failure)
        end
      end
  end

end