module OpenFresk
  class PublicParticipationsController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :set_training_session
    before_action :set_participation, only: %i[personal_informations decline_participation]

    def ticket_choice
      # @language = Languages::SetLanguage.new(params, current_user).call
      if @training_session.nil?
        flash[:alert] = t('training_sessions.not_found')
        return redirect_to public_training_sessions_path(language: @language)
      end
      @product_configurations = @training_session.product_configurations
                                                 .includes([:product])
                                                 .where.not(product: { identifier: 'COUPON' })
                                                 .order(before_tax_price_cents: :desc)

      @product_configuration_coupon = @training_session.country
                                                       .product_configurations
                                                       .joins(:product)
                                                       .where(product: { category: @training_session.category })
                                                       .where(product: { identifier: 'COUPON' })
                                                       .includes([:product]).first

      return unless @product_configurations.map(&:before_tax_price_cents) == [0]

      redirect_post(
        personal_informations_training_session_public_participations_path(@training_session, language: @language),
        params: {
          custom_price: nil,
          product_configuration_id: @product_configurations.first.id,
          coupon_code: nil,
          user_token: params[:user_token]
        },
        options: {
          authenticity_token: 'auto'
        }
      )
    end

    def personal_informations
      @product_configuration_id = params[:product_configuration_id]
      @product_configuration = ProductConfiguration.find(params[:product_configuration_id])

      if @product_configuration.coupon?
        command = Coupons::ConsumeCoupon.new(training_session: @training_session,
                                             code: params[:coupon_code])
        command.validate_coupon!
        if command.errors.present?
          flash[:alert] = command.errors.full_messages.to_sentence
          return redirect_to ticket_choice_training_session_public_participations_path(@training_session)
        end
      end

      @custom_price = params[:custom_price]
      @coupon_code = params[:coupon_code]
      @product = @product_configuration.product
      # @presenter = CgvCguPresenter.new(@training_session)
    end

    def create
      create_update
    end

    def update
      create_update
    end

    def decline_participation
      transaction = Transaction.find(params[:transaction_id]) if params[:transaction_id].present?
      if @participation.waiting_for_payment? || @participation.pending?
        ActiveRecord::Base.transaction do
          @participation.update!(status: Participation::Declined)
          transaction.destroy! if params[:transaction_id].present?
        end
        redirect_to public_training_sessions_path,
                    notice: t('my_participation.cancelled')
      else
        redirect_to show_public_training_session_path(@training_session, user_token: @participation.user.token)
      end
    end

    private

    def create_update
      @language = Languages::SetLanguage.new(params, current_user).call
      return if participation_exists?

      product_params = {
        custom_price: params[:custom_price],
        product_configuration_id: params[:product_configuration_id],
        coupon_code: params[:coupon_code]
      }

      command = Transactions::TransactionManager.new(
        product_params: product_params,
        participation_params: participation_params,
        training_session: @training_session,
        billing_params: billing_params,
        language: @language
      )

      @participation = command.call
      transaction = command.transaction
      if @participation&.success? && transaction&.present?
        @participation = @participation.result
        if transaction.product_configuration.product.charged?
          redirect_to new_payment_path(transaction_id: transaction.id, language: @language)
        else
          @participation.update!(status: Participation::Confirmed)
          Participations::SessionRegistrationConfirmationJob.perform_later(@participation.id)
          flash[:notice] = t('my_participation.confirmed', email: @participation.user.email)
          redirect_to show_public_training_session_path(transaction.training_session.id,
                                                        user_token: @participation.user.token, language: @language)
        end
      else
        flash[:alert] = command.errors.full_messages.to_sentence
        redirect_post(
          personal_informations_training_session_public_participations_path(@training_session),
          params: {
            language: @language,
            checkbox_invoicing_details: params[:checkbox_invoicing_details],
            custom_price: params[:custom_price],
            product_configuration_id: params[:product_configuration_id],
            coupon_code: params[:coupon_code],
            participation: {
              email: participation_params[:email],
              first_name: participation_params[:first_name],
              last_name: participation_params[:last_name],
              country_id: participation_params[:country_id],
              cgu: participation_params[:cgu],
              confirm_token: participation_params[:confirm_token],
              decline_token: participation_params[:decline_token],
              invoicing_firstname: participation_params[:invoicing_firstname],
              invoicing_lastname: participation_params[:invoicing_lastname],
              invoicing_street: participation_params[:invoicing_street],
              invoicing_zip: participation_params[:invoicing_zip],
              invoicing_city: participation_params[:invoicing_city]
            },
            billing_info: {
              contact: {
                firstname: billing_params&.dig(:contact, :firstname),
                lastname: billing_params&.dig(:contact, :lastname),
                email: billing_params&.dig(:contact, :email)
              },
              organisation: {
                name: billing_params&.dig(:organisation, :name),
                identifier: billing_params&.dig(:organisation, :identifier),
                vatin: billing_params&.dig(:organisation, :vatin)
              }
            }
          },
          options: {
            authenticity_token: 'auto'
          }
        )
      end
    end

    def set_training_session
      @training_session = TrainingSession.find(params[:training_session_id])
    end

    def create_participation(participation_status)
      Participations::CreateParticipation.new(
        participation_params: participation_params,
        current_user: current_user,
        training_session: @training_session,
        participation_status: participation_status
      )
    end

    def participation_exists?
      user = User.find_by(email: participation_params[:email])
      participation = @training_session.participations.find_by(user_id: user&.id, training_session: @training_session)
      transaction = Transaction.find_by(participation: participation)
      if transaction&.status == Transaction::Pending
        flash[:notice] = t('my_participation.waiting_for_payment')
        redirect_to new_payment_path(transaction_id: transaction.id, language: @language)
        true
      elsif !participation.nil? && participation.waiting_for_payment?
        flash[:notice] = t('my_participation.ticket_choice')
        redirect_to ticket_choice_training_session_public_participation_path(@training_session, participation,
                                                                             language: @language)
        true
      elsif !participation.nil? && participation.confirmed?
        flash[:notice] = t('my_participation.already_confirmed')
        redirect_to show_public_training_session_path(@training_session, user_token: participation.user.token,
                                                                         language: @language)
        true
      end
    end

    def participation_params
      params
        .require(:participation)
        .permit(
          :email,
          :first_name,
          :last_name,
          :country_id,
          :cgu,
          :confirm_token,
          :decline_token,
          :invoicing_company_name,
          :invoicing_firstname,
          :invoicing_lastname,
          :invoicing_street,
          :invoicing_zip,
          :invoicing_city
        )
    end

    def billing_params
      params[:billing_info]&.permit(contact: %i[firstname lastname email],
                                    organisation: %i[name identifier
                                                     vatin])
    end

    def set_participation
      @participation = if current_user
                         @training_session.participations.find_by(user: current_user)
                       elsif params[:user_token].present?
                         @training_session.participations.find_by(user: User.find_by(token: params[:user_token]))
                       elsif params[:id].present?
                         Participation.find(params[:id])
                       else
                         Participation.new
                       end
    end
  end
end
