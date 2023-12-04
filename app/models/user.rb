class User < ApplicationRecord
  belongs_to :group

  validates :line_id, presence: true
  validates :group_id, presence: true
  validates :notification, inclusion: { in: [true, false] }

  enum role: { general: 0, leader: 1, admin: 2 }
end
