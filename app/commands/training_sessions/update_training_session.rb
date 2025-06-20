module TrainingSessions
  class UpdateTrainingSession
    include TrainingSessions::TrainingSessionTime

    def initialize(training_session_params:, training_session:, current_user:, recurrent:, contact:, context:)
      @training_session = training_session
      @training_session_params = training_session_params
      @current_user = current_user
      @recurrent = recurrent
      @contact = contact
      @context = context
    end

    def call
      set_training_time(
        training_session:,
        params: training_session_params,
        past: false
      )
      training_session.update(training_session_params)
      training_session
    end

    private

    attr_reader :training_session_params, :training_session, :current_user, :recurrent
  end
end
