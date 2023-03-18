class User < ApplicationRecord
  has_person_name
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable

  validates_presence_of :name
  validates_presence_of :address
  validates_presence_of :contact_number
end
