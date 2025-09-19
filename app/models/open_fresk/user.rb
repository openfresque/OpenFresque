module OpenFresk
  class User < ApplicationRecord
    USER_ROLES = %w[user facilitator advanced_facilitator].freeze

    self.table_name = 'users'
    has_secure_password

    has_many :participations, dependent: :destroy

    validates :user_role, presence: true, inclusion: { in: USER_ROLES }

    USER_ROLES.each do |role|
      define_method("#{role}?") { user_role == role }
      scope role, -> { where(user_role: role) }
    end

    def country
      Country.find_by(name: 'France')
    end

    def fullname
      "#{firstname&.titleize_with_dashes} #{lastname&.titleize_with_dashes}"
    end
  end
end
