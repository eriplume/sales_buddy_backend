class Task < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :title, presence: true, length: { maximum: 20 }
  validates :is_group_task, inclusion: { in: [true, false] }
  validates :deadline, presence: true
  validates :importance, presence: true

  def user_name
    user.name
  end
end
