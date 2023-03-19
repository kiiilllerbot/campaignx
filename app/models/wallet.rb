class Wallet < ApplicationRecord
  belongs_to :user

  after_create :add_secret_hash

  def add_secret_hash
    hash = SecureRandom.hex(8)

    unless Wallet.exists?(secret_hash: hash)
      self.update_attribute(:secret_hash, hash)
    else
      hash = SecureRandom.hex(8)
      self.update_attribute(:secret_hash, hash)
    end
  end

  enum status: ["Active", "Locked"]
end
