module OpenFresk
  module Participations
    module LastMinuteHelper
      def last_minute_title(anonymous_participant)
        if anonymous_participant == true
          t("participations.edit_anonymous")
        else
          t("participations.new_participation")
        end
      end

      def last_minute_submit_btn(anonymous_participant)
        if anonymous_participant == true
          t("save")
        else
          t("participations.create_participation")
        end
      end
    end
  end
end