class User < ApplicationRecord
  before_validation :set_default_group, on: :create

  belongs_to :group
  has_many :dairy_records, dependent: :destroy
  has_many :weekly_reports, dependent: :destroy
  has_many :weekly_targets, dependent: :destroy

  validates :line_id, presence: true
  validates :notifications, inclusion: { in: [true, false] }

  enum role: { general: 0, leader: 1, admin: 2 }

  def self.authenticate_with_line_id(line_id, name)
    user = find_or_initialize_by(line_id:)
    user.name = name if user.new_record? || user.name != name
    user
  end

  private

  def set_default_group
    self.group_id ||= 1 # 1はデフォルトのグループID
  end
end
