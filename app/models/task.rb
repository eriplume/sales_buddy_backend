class Task < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :completed_by, class_name: 'User', optional: true, inverse_of: :completed_tasks
  has_many :comments, dependent: :destroy
  
  validates :title, presence: true, length: { maximum: 20 }
  validates :is_group_task, inclusion: { in: [true, false] }
  validates :deadline, presence: true
  validates :importance, presence: true

  delegate :name, to: :user, prefix: true
  delegate :image_url, to: :user, prefix: true

  def completed_by_name
    completed_by&.name
  end
end
