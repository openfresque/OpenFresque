module OpenFresk
  class ParticipationsController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[show refund cancel]
    before_action :verify_token!, only: %i[show refund cancel]
    before_action :set_training_session, only: %i[create]
    before_action :set_participation, only: %i[show refund cancel add_organiser]
    before_action :set_transaction, only: %i[show refund]
    before_action :set_language, only: %i[show cancel refund]

    def show
      return if @participation.user == @current_user

      redirect_to public_training_sessions_path(language: @language)
    end

    def cancel
      raise "cannot cancel participation" unless @participation.cancelable?

      @participation.update!(status: Participation::Declined)
      CancelParticipationJob.perform_later(@participation.training_session.id, @participation.user.id)
      flash[:notice] = t("my_participation.cancelled")
      redirect_to show_public_training_session_path(@participation.training_session.id,
                                                    user_token: @participation.user.token, language: @language)
    end

    def refund
      raise "cannot refund participation" unless @participation.cancelable? && @participation.refundable?

      if @transaction.charged? && @transaction.payment_intent_id && !@transaction.refunded?
        @participation.update!(status: Participation::Declined)
        begin
          Stripe::Refund.create({payment_intent: @transaction.payment_intent_id})
        rescue Stripe::InvalidRequestError => e
          Sentry.capture_exception(e)
          @transaction.update!(status: Transaction::Failure)
          flash[:alert] = t("my_participation.refund_failed")
          return redirect_to show_public_training_session_path(@participation.training_session.id,
                                                               user_token: @participation.user.token, language: @language)
        end
        @transaction.update!(status: Transaction::Refund)
        CancelParticipationJob.perform_later(@participation.training_session.id, @participation.user.id)
      end
      flash[:notice] = t("my_participation.refunded")
      redirect_to public_training_sessions_path(language: @language)
    end

    def add_organiser
      @participation.edit_session_permission ? @participation.update(edit_session_permission: false) : @participation.update(edit_session_permission: true)
      redirect_back(fallback_location: root_path)
    end

    private

      def set_participation
        @participation = Participation.find(params[:participation_id] || params[:id])
      end

      def set_transaction
        @transaction = Transaction.where(participation: @participation).last
      end

      def set_training_session
        @training_session = TrainingSession.find(params[:training_session_id])
      end

      def set_language
        @language = Languages::SetLanguage.new(params, current_user).call
      end
  end

end
