module OpenFresk
  class User < ApplicationRecord
    self.table_name = 'users'
    has_secure_password

    def fullname
      "#{firstname&.titleize_with_dashes} #{lastname&.titleize_with_dashes}"
    end
  end
end
