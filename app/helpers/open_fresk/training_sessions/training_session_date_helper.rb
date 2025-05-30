module OpenFresk
  module TrainingSessions
    module TrainingSessionDateHelper
      def training_session_date(session)
        icon = fa_icon("clock", type: :regular)
        date = l(session.date, format: :long)
        time = training_session_time(session)
        time_zone = t("time_of", time_zone: session.time_zone)
        content_tag(:div, "#{icon} #{date}, #{time} (#{time_zone})".html_safe)
      end

      def training_session_time(session)
        t("from_to",
          from: l(session.local_start_time, format: :short),
          to: l(session.local_end_time, format: :short)).downcase
      end
    end
  end
end