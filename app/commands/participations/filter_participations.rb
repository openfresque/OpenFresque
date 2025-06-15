module Participations
  class FilterParticipations
    prepend SimpleCommand

    def initialize(participations:, params_filter:)
      @participations = participations
      @params_filter = params_filter
    end

    def call
      case @params_filter
      when "confirmed"
        @participations.confirmed
      when "pending"
        @participations.pending
      when "declined"
        @participations.declined
      else
        @participations.confirmed
                       .or(@participations.present)
                       .or(@participations.pending)
                       .or(@participations.declined)
      end
    end

    private

    attr_reader :participations, :params_filter
  end
end
