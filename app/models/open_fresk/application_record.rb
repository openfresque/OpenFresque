module OpenFresk
  class ApplicationRecord < ActiveRecord::Base
    include OpenFresk::Extensions::StringEnum
    self.abstract_class = true

    def self.[](attribute)
      arel_table[attribute]
    end
  end
end
