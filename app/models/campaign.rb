class Campaign < ApplicationRecord
  belongs_to :user

  validates_presence_of :title
  validates_presence_of :message
  validate :character_input

  scope :last_three_months, -> { where('created_at >= ?', DateTime.now - 3.months) }

  def character_input
    length = title.length + message.length

    if length > 145
      errors.add(:base, "Maximum 145 characters are allowed for title and message")
    end
  end
end
