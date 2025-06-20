module OpenFresk
  class BillingInfo < ApplicationRecord
    self.table_name = 'billing_infos'

    belongs_to :user
    belongs_to :contact, class_name: "User", foreign_key: :contact_id
    belongs_to :billing_transaction, class_name: "Transaction", foreign_key: :transaction_id
  end
end