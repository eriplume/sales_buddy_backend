class Job < ApplicationRecord
  has_many :job_records, dependent: :destroy
  validates :name, presence: true, length: { maximum: 20 }
end
