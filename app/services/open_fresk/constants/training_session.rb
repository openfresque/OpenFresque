module OpenFresk
  module Constants
    module TrainingSession
      START_TIME_DELTA_T = 15 # I can register participants starting 15min before the start_time of a session
      END_TIME_DELTA_T = 0 # Before we use it to register participants after 1 week. Now we remove the one week and it's only used for views.
      DEFAULT_DISTANCE = 5
      MIN_DISTANCE = 1
      MAX_DISTANCE = 200
      SHORT_DURATION = 3
      LONG_DURATION = 7
    end
  end

end