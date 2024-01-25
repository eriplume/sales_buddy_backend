class Task < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :completed_by, class_name: 'User', optional: true

  validates :title, presence: true, length: { maximum: 20 }
  validates :is_group_task, inclusion: { in: [true, false] }
  validates :deadline, presence: true
  validates :importance, presence: true

  def user_name
    user.name
  end

  def completed_by_name
    completed_by&.name
  end
end
