module OpenFresk
  class User < ApplicationRecord
    def fullname
      "#{firstname&.titleize_with_dashes} #{lastname&.titleize_with_dashes}"
    end
  end
end
