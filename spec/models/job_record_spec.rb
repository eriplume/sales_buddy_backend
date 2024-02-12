require 'rails_helper'

RSpec.describe JobRecord, type: :model do
  describe 'validation' do
    let(:job) { create(:job) }
    let(:user) { create(:user) }
    let(:job_record) { create(:job_record, user:, job:) }
    before do
      job_record
    end

    it 'is valid with all attributes' do
      job_record = build(:job_record)
      expect(job_record).to be_valid
      expect(job_record.errors).to be_empty
    end

    it 'is invalid without date' do
      record_without_date = build(:job_record, date: nil)
      expect(record_without_date).to be_invalid
      expect(record_without_date.errors[:date]).not_to be_empty
    end

    it 'is invalid with a duplicate job_id and date for the same user' do
      duplicate_job_record = build(:job_record, user: job_record.user, job: job_record.job, date: job_record.date)
      expect(duplicate_job_record).to be_invalid
      expect(duplicate_job_record.errors[:job_id]).not_to be_empty
    end
  end
end
