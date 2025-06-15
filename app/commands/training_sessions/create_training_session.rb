module TrainingSessions
  class CreateTrainingSession
    include TrainingSessions::TrainingSessionTime

    def initialize(training_session_params:, current_user:, contact:, past:, context:)
      @training_session_params = training_session_params
      @current_user = current_user
      @contact = contact
      @past = past
      @context = context
      @training_session = TrainingSession.new
    end

    def call
      set_training_time(
        training_session:,
        params: training_session_params,
        past: @past
      )
      training_session.assign_attributes(training_session_params)
      training_session.created_by_user_id = current_user.id
      training_session.save

      training_session
    end

    private

    attr_reader :training_session_params, :current_user, :training_session
  end
end
