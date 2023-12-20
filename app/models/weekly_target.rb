class WeeklyTarget < ApplicationRecord
  belongs_to :user

  validates :target, presence: true,
                    numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 200 }
  validates :start_date, presence: true, uniqueness: { scope: :user_id }
  validates :end_date, presence: true
end
