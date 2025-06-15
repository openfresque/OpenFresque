module OpenFresk
  class Participation < ApplicationRecord
    self.table_name = "participations"
    include Decorable

    belongs_to :user
    belongs_to :training_session, inverse_of: :participations
    belongs_to :animator, class_name: "User", foreign_key: "animator_id"
    has_many :transactions, dependent: :destroy

    string_enum status: %i[waiting_for_payment pending confirmed declined present].freeze

    scope :participant, -> { where("animator_id != user_id OR animator_id IS NULL").includes(:user) }
    scope :present, lambda {
      where(status: Participation::Present).where("animator_id != user_id OR animator_id IS NULL").includes(:user)
    }
    scope :confirmed, lambda {
      where(status: Participation::Confirmed).where("animator_id != user_id OR animator_id IS NULL").includes(:user)
    }
    scope :waiting_for_payment, lambda {
      where(status: Participation::WaitingForPayment).where("animator_id != user_id OR animator_id IS NULL").includes(:user)
    }
    scope :pending, lambda {
      where(status: Participation::Pending).where("animator_id != user_id OR animator_id IS NULL").includes(:user)
    }
    scope :declined, lambda {
      where(status: Participation::Declined).where("animator_id != user_id OR animator_id IS NULL").includes(:user)
    }
    scope :animator, -> { where("animator_id = user_id").includes(:user) }

    scope :my_presents, lambda { |user|
      where(status: Participation::Present).where("animator_id = ?", user&.id, user&.id).where.not(user_id: user&.id).includes(:user)
    }
    scope :animators, -> { where(animator_role: [Participation::Animator]).includes(:user) }

    validates_uniqueness_of :user, scope: :training_session
    validates :user_id, :status, presence: true
    validates_presence_of :training_session

    delegate :start_time, to: :training_session

    def waiting_for_payment?
      status == Participation::WaitingForPayment
    end

    def pending?
      status == Participation::Pending
    end

    def confirmed?
      status == Participation::Confirmed
    end

    def declined?
      status == Participation::Declined
    end

    def present?
      status == Participation::Present
    end

    def my_present?(user)
      [animator].include?(user) && present?
    end

    def cancelable?
      start_time.future?
    end

    def charged?
      transactions&.last&.charged?
    end

    def participant?
      animator_role.nil?
    end

    def user_email
      user&.email
    end

    def successful_transaction
      transactions.find_by(status: Transaction::Success)
    end
  end
end