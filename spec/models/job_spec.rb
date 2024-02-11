require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      job = build(:job)
      expect(job).to be_valid
      expect(job.errors).to be_empty
    end

    it 'is invalid without name' do
      job_without_name = build(:job, name: nil)
      expect(job_without_name).to be_invalid
      expect(job_without_name.errors[:name]).not_to be_empty
    end

    it 'is invalid with name more than 20 characters' do
      job_with_long_name = build(:job, name: 'a' * 21)
      expect(job_with_long_name).to be_invalid
      expect(job_with_long_name.errors[:name]).not_to be_empty
    end
  end
end
