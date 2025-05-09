module OpenFresk
  class TrainingSessionsController < ApplicationController
    def index
    end

    private

      def sessions_lists
        public_opportunities
      end

      def public_opportunities
        training_sessions = TrainingSession.futur
        @my_training_sessions = training_sessions.my_sessions(current_user)
      end
  end
end