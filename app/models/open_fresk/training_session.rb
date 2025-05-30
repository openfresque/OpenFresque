module OpenFresk
  class TrainingSession < ApplicationRecord
    self.table_name = 'training_sessions'

    include ::TrainingSessions::Timings
    include ::TrainingSessions::Staffing

    belongs_to :language
    belongs_to :country

    string_enum category: %i[atelier formation].freeze
    string_enum format: %i[onsite online].freeze

    scope :futur, -> { where('end_time >= ?', DateTime.current.beginning_of_day).order(date: :asc) }
    scope :organized_by, ->(user) { where(created_by_user_id: user&.id) }
    scope :my_sessions, ->(user) { where(id: organized_by(user)) }

    delegate :future?, to: :end_time

    #TODO: remove me when timezones are implemented
    def local_start_time
      start_time
    end

    # TODO: remove me when timezones are implemented
    def local_end_time
      end_time
    end

    # TODO: remove me when seats are implemented
    def confirmed_present_count
      1
    end

    # TODO: remove me when seats are implemented
    def animator_count
      1
    end

    #TODO: implement when participations are implemented
    def destroyable?
      true
      # participations.where(status: Participation::Confirmed).none? &&
      #   participations.where(status: Participation::Present).none?
    end

    def created_by_user
      User.find(created_by_user_id)
    end
  end
end
