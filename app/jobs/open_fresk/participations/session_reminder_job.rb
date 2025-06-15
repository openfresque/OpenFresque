module OpenFresk
  module Participations
    class SessionReminderJob < ApplicationJob
      include Rails.application.routes.url_helpers
      sidekiq_options queue: :critical

      def perform(participation_id)
        participation = Participation.find(participation_id)
        user = participation.user
        language = Languages::SetEmailLanguage.new(language: user.native_language).call
        subject = I18n.t(
          "participation.session_reminder.subject_#{subject_translation_key(participation)}",
          locale: language
        )
        ParticipationMailer.with(locale: language)
        .session_reminder_email(subject: subject,
                                user: user,
                                participation: participation)
        .deliver_now
      end

      private

        def subject_translation_key(participation)
          if participation.participant?
            "participant"
          else
            "animator"
          end
        end
    end
  end
end