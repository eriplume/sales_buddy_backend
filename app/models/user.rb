class User < ApplicationRecord
  before_validation :set_default_group, on: :create

  belongs_to :group

  validates :line_id, presence: true
  validates :notifications, inclusion: { in: [true, false] }

  enum role: { general: 0, leader: 1, admin: 2 }

  private

  def set_default_group
    self.group_id ||= 1 # 1はデフォルトのグループID
  end
end
