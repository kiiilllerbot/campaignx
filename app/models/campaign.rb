class Campaign < ApplicationRecord
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :message

  scope :last_three_months, -> { where('created_at >= ?', DateTime.now - 3.months) }
end
