module OpenFresk
  class TrainingSession < ApplicationRecord
    self.table_name = 'training_sessions'

    scope :futur, -> { where("end_time >= ?", DateTime.current.beginning_of_day).order(date: :asc) }
    scope :organized_by, ->(user) { where(created_by_user_id: user&.id) }
    scope :my_sessions, ->(user) { where(id: organized_by(user)) }
  end
end