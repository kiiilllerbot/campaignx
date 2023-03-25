class Transaction < ApplicationRecord
  attr_accessor :rails_admin
  acts_as_paranoid
  belongs_to :user
  after_create :update_credit_information

  def update_credit_information
    unless self.rails_admin == "0"
      transaction_type = 'Topup'
      wallet = Wallet.find_by_id(user_id)
      balance = wallet.balance
      wallet.update_attribute(:balance, balance + amount)
    end
  end
end
