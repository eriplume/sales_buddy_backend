class JobRecord < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates :date, presence: true
  validates :job_id, uniqueness: { scope: [:user_id, :date] }
end
