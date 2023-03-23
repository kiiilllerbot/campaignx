class Audience < ApplicationRecord
  acts_as_paranoid
  belongs_to :user

  validates_presence_of :name
  validates_presence_of :email, uniqueness: true
  validates_presence_of :contact_number, uniqueness: true
end
