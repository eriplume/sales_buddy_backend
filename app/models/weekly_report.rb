class WeeklyReport < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 300 }
  validates :start_date, presence: true, uniqueness: { scope: :user_id }
  validates :end_date, presence: true
end
