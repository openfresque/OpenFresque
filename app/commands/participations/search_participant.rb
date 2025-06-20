module Participations
  class SearchParticipant
    include SimpleCommand

    def initialize(params_search:, participations:)
      @params_search = params_search
      @participations = participations
    end

    def call
      return @participations if @params_search.blank?

      @participations_empty = @participations

      @search = params_search.downcase
      @participations = participations.where(users: {email: @search})
                                      .or(@participations.where(users: {firstname: @search}))
                                      .or(@participations.where(users: {lastname: @search}))
    end

    private

    attr_reader :params_search, :participations
  end
end
