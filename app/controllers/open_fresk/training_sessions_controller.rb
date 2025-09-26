module OpenFresk
  class TrainingSessionsController < ApplicationController
    before_action :set_training_session,
                  only: %i[edit update destroy product_configurations set_product_configurations show_public]
    skip_before_action :authenticate_user!, only: %i[public show_public]

    def public
      @training_sessions = TrainingSession.
                           futur.
                           order(start_time: :asc)
    end

    def index
      public_opportunities
    end

    def new
      @training_session = ::TrainingSession.new
    end

    def edit
      @facilitation_language = @training_session.language_id
      @start_time = @training_session.local_start_time.strftime("%H:%M")
      @end_time = @training_session.local_end_time.strftime("%H:%M")
    end

    def update
      command = ::TrainingSessions::UpdateTrainingSession.new(
        training_session_params: training_session_params,
        training_session: @training_session,
        current_user: current_user,
        recurrent: params[:recurrent],
        contact: params.dig(:contact),
        context: params.dig(:context)
      )
      command.call

      if @training_session.errors.blank?
        redirect_to product_configurations_training_session_path(@training_session), notice: t("training_sessions.updated")
      else
        render :edit
      end
    end

    def create
      command = ::TrainingSessions::CreateTrainingSession.new(
        training_session_params: training_session_params,
        current_user: current_user,
        contact: params.dig(:contact),
        past: params.dig(:past),
        context: params.dig(:context)
      )
      @training_session = command.call

      if @training_session.errors.blank?
        redirect_to product_configurations_training_session_path(@training_session),
                    notice: t("training_sessions.created")
      else
        render :new
      end
    end

    def product_configurations
      @product_configurations = @training_session
                                .country
                                .product_configurations
                                .joins(:product)
                                .where(product: {category: @training_session.category})
                                .where.not(product: {identifier: "COUPON"})
                                .order(:before_tax_price_cents)
                                .includes([:product])
    end

    def set_product_configurations
      product_configurations = ProductConfiguration.where(id: params[:product_configurations])

      if product_configurations.blank?
        redirect_to product_configurations_training_session_path(@training_session),
                    notice: t("training_sessions.no_product_selected")
        return
      end

      @training_session.product_configuration_sessions.destroy_all

      product_configurations.each do |product_configuration|
        ProductConfigurationSession.create(
          training_session: @training_session,
          product_configuration: product_configuration
        )
      end
      redirect_to training_session_path(@training_session),
                  notice: t("training_sessions.updated")
    end

    def show_public
      @participation = Participation.new(training_session: @training_session)
      training_session_products
    end

    def destroy
      if @training_session.destroy!
        redirect_to root_path, notice: t("training_sessions.destroy_session_notice")
      else
        render :edit
      end
    end

    private
      def training_session_params
        params
        .require(:training_session)
        .permit(
          :description,
          :language_id,
          :country_id,
          :date,
          :start_hour,
          :end_hour,
          :category,
          :format,
          :connexion_url,
          :room,
          :street,
          :city,
          :zip,
          :country,
          :capacity,
          :public,
          :session_info,
          :latitude,
          :longitude
        )
      end

      def sessions_lists
        public_opportunities
      end

      def public_opportunities
        training_sessions = ::TrainingSession.futur
        @my_training_sessions = training_sessions.my_sessions(current_user)
      end

      def set_training_session
        @training_session = ::TrainingSession.find(params[:id])
      end

      def training_session_products
        @products = @training_session
                    .product_configuration_sessions
                    .includes(:product_configuration)
                    .order("product_configurations.before_tax_price_cents")
      end
  end
end
