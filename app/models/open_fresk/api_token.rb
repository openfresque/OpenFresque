module OpenFresk
  class ApiToken < ApplicationRecord
    before_create :generate_token

    validates :label, presence: true

    private

    def generate_token
      self.token = SecureRandom.hex(32) # 64 caractères
    end
  end
end
