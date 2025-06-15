module TrainingSessions
  module TrainingSessionTime
    def set_training_time(training_session:, params:, past:)
      date = Date.parse(params.delete(:date))
      training_session.date = date
      training_session.start_time = Time.zone.parse(params.delete(:start_hour), date).utc
      training_session.end_time = Time.zone.parse(params.delete(:end_hour), date).utc
    end
  end
end
