module OpenFresk
  module Participations
    class SessionRegistrationConfirmationJob < ApplicationJob
      include Rails.application.routes.url_helpers
      sidekiq_options queue: :critical

      def perform(participation_id)
        participation = Participation.find(participation_id)
        user = participation.user
        language = Languages::SetEmailLanguage.new(language: user.native_language).call
        subject = I18n.t("participation.session_registration_confirmation.subject", locale: language)
        ParticipationMailer.with(locale: language)
        .session_registration_confirmation_email(subject: subject,
                                                 user: subject,
                                                 participation: participation)
        .deliver_now
      end
    end
  end
end