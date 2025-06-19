module OpenFresk
  class ParticipationMailer < ApplicationMailer
    include Rails.application.routes.url_helpers

    def session_registration_confirmation_email(subject:, user:, participation:)
      @subject = subject
      @participation = participation
      @user = user
      @participation = participation
      @training_session = @participation.training_session.decorate
      @language = I18n.locale.to_s
      build_cta_urls

      ics_content = Ics::Generate.new(session: @training_session, current_user: @user).call.result
      attachments[ics_content[:name]] = {mime_type: "text/calendar", content: ics_content[:content]}

      mail(to: recipient_email, subject: @subject)
    end

    def session_reminder_email(subject:, user:, participation:)
      @subject = subject
      @participation = participation
      @user = user
      @training_session = @participation.training_session.decorate
      @participation = participation
      @language = I18n.locale.to_s
      build_cta_urls
      mail(to: recipient_email, subject: @subject)
    end

    def send_certificate_email(user:, participation:, participation_certificate_url:, training_registration_facilitator_url:)
      @user = user
      @participation = participation
      @participation_certificate_url = participation_certificate_url
      @training_registration_facilitator_url = training_registration_facilitator_url

      mail(
        to: recipient_email,
        template_path: "mailers/participation_mailer/email_content/post_session"
      )
    end

    private

      def build_cta_urls
        if @participation.participant?
          build_participant_cta_urls
        else
          @session_url = training_session_url(@training_session.id, host: ENV["HOST"])
        end
      end

      def build_participant_cta_urls
        @invoice_url = participation_url(@participation.id, host: ENV["HOST"], token: @user.token)
        @invitation_url = participation_participation_invitations_url(@participation, host: ENV["HOST"], format: :pdf)
        @reset_password_url = future_facilitator_access_index_url(host: ENV["HOST"], language: @language)
      end
  end
end