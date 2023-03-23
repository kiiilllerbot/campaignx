class User < ApplicationRecord
  has_person_name
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable

  validates_presence_of :name
  validates_presence_of :brand
  validates_presence_of :address
  validates_presence_of :contact_number

  has_one :wallet
  has_many :audiences, dependent: :destroy

  after_create :assign_wallet

  def assign_wallet
    user = User.find(self.id)

    unless user.wallet.present? && !user.admin?
      Wallet.create(balance: 0, user_id: user.id)
    end
  end
end
