module OpenFresk
  class User < ApplicationRecord
    self.table_name = 'users'

    def fullname
      "#{firstname&.titleize_with_dashes} #{lastname&.titleize_with_dashes}"
    end
  end
end
