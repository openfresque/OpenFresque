module OpenFresk
  class User < ApplicationRecord
    self.table_name = 'users'
    has_secure_password

    has_many :participations, dependent: :destroy

    string_enum user_role: UserRole.all.map { |user_role| user_role.name }

    validates :user_role, presence: true

    def country
      Country.find_by(name: 'France')
    end

    def fullname
      "#{firstname&.titleize_with_dashes} #{lastname&.titleize_with_dashes}"
    end
  end
end
