class MonthlyReport < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :month, presence: true, uniqueness: { scope: :user_id }
end
