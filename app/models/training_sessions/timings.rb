module TrainingSessions
  module Timings
    def local_start_time
      # start_time.in_time_zone(time_zone)
      # start_time + (Time.now.in_time_zone(time_zone).utc_offset / 3600).hours
      # start_time + (updated_at.in_time_zone(time_zone).utc_offset / 3600).hours
      start_time.in_time_zone(time_zone)
    end

    def local_end_time
      # end_time.in_time_zone(time_zone)
      # end_time + (Time.now.in_time_zone(time_zone).utc_offset / 3600).hours
      # end_time + (updated_at.in_time_zone(time_zone).utc_offset / 3600).hours
      end_time.in_time_zone(time_zone)
    end

    def user_local_start_time(user)
      # start_time.in_time_zone(user.time_zone)
      # start_time + (Time.now.in_time_zone(user.time_zone).utc_offset / 3600).hours
      # start_time + (updated_at.in_time_zone(user.time_zone).utc_offset / 3600).hours
      start_time.in_time_zone(user.time_zone)
    end

    def user_local_end_time(user)
      # end_time.in_time_zone(user.time_zone)
      # end_time + (Time.now.in_time_zone(user.time_zone).utc_offset / 3600).hours
      # end_time + (updated_at.in_time_zone(user.time_zone).utc_offset / 3600).hours
      end_time.in_time_zone(user.time_zone)
    end

    def passed?
      endtime = DateTime.new(
        date.year,
        date.month,
        date.day,
        end_time.hour,
        end_time.min,
        end_time.sec,
        time_zone
      )
      end_time_delta_t = ((DateTime.now - endtime) * 24 * 60).to_i
      end_time_delta_t > Constants::TrainingSession::END_TIME_DELTA_T
    end

    def started?
      now = DateTime.now
      starttime = DateTime.new(
        date.year,
        date.month,
        date.day,
        start_time.hour,
        start_time.min,
        start_time.sec,
        time_zone
      )
      start_time_delta_t = ((starttime - now) * 24 * 60).to_i
      start_time_delta_t < Constants::TrainingSession::START_TIME_DELTA_T
    end

    def can_emarged?
      start_time.in_time_zone(time_zone) - Constants::TrainingSession::START_TIME_DELTA_T.minutes < DateTime.now.in_time_zone(time_zone)
    end

    def has_started?
      start_time.in_time_zone(time_zone) < DateTime.now.in_time_zone(time_zone)
    end

    def legacy?
      created_at > end_time
    end

    def ended?
      DateTime.current > end_time
    end
  end
end
