module Participations
  class UpdateParticipation
    include SimpleCommand

    def initialize(participant:, current_user:, training_session:)
      @participant = participant
      @current_user = current_user
      @training_session = training_session
    end

    def call
      @participation = training_session.participations.find_by(user: participant)

      if @participation.status == Participation::Present &&
         [@current_user.id].include?(@participation.animator_id)
        animator = nil
        status = Participation::Confirmed
        presence_recorded_at = nil
      elsif @participation.status == Participation::Confirmed
        animator = @current_user
        status = Participation::Present
        presence_recorded_at = Time.current
      else
        return @participation
      end

      @participation.animator = animator
      @participation.status = status
      @participation.presence_recorded_at = presence_recorded_at
      @participation.save

      @participation
    end

    private

    attr_reader :participant, :current_user, :training_session
  end
end
