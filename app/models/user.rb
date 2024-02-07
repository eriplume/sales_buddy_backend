class User < ApplicationRecord
  before_validation :set_default_group, on: :create

  belongs_to :group
  has_many :dairy_records, dependent: :destroy
  has_many :weekly_reports, dependent: :destroy
  has_many :monthly_reports, dependent: :destroy
  has_many :weekly_targets, dependent: :destroy
  has_many :job_records, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :completed_tasks, class_name: 'Task', foreign_key: 'completed_by_id', dependent: :nullify,
                             inverse_of: :completed_by
  has_many :comments, dependent: :destroy

  validates :line_id, presence: true
  validates :notifications, inclusion: { in: [true, false] }

  enum role: { general: 0, leader: 1, admin: 2 }

  def self.authenticate_with_line_id(line_id, name, image_url)
    user = find_or_initialize_by(line_id:)
    user.name = name if user.new_record? || user.name != name
    user.image_url = image_url if user.new_record? || user.image_url != image_url
    user
  end

  def as_custom_json
    as_json(only: %i[id name group_id]).merge({
                                                roleValue: role_before_type_cast
                                              })
  end

  private

  def set_default_group
    self.group_id ||= 1 # 1はデフォルトのグループID
  end
end
