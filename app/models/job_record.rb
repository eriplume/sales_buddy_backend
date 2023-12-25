class JobRecord < ApplicationRecord
  belongs_to :user
  belongs_to :job

  validates :date, presence: true
  validates :job_id, uniqueness: { scope: %i[user_id date] }

  def self.create_from_job_names(user_id, date, job_names)
    transaction do
      job_names.each do |job_name|
        job = Job.find_or_create_by(name: job_name)
        record = new(user_id:, job_id: job.id, date:)

        raise ActiveRecord::Rollback unless record.save
      end
    end
  end
end
