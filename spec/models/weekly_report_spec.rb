require 'rails_helper'

RSpec.describe WeeklyReport, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:weekly_report) { create(:weekly_report, user:) }
    before do
      weekly_report
    end

    it 'is valid with all attributes' do
      weekly_report = build(:weekly_report)
      expect(weekly_report).to be_valid
      expect(weekly_report.errors).to be_empty
    end

    it 'is invalid without content' do
      report_without_content = build(:weekly_report, content: nil)
      expect(report_without_content).to be_invalid
      expect(report_without_content.errors[:content]).not_to be_empty
    end

    it 'is invalid with content more than 300 characters' do
      report_with_long_content = build(:weekly_report, content: 'a' * 301)
      expect(report_with_long_content).to be_invalid
      expect(report_with_long_content.errors[:content]).not_to be_empty
    end

    it 'is invalid without start_date' do
      report_without_start_date = build(:weekly_report, start_date: nil)
      expect(report_without_start_date).to be_invalid
      expect(report_without_start_date.errors[:start_date]).not_to be_empty
    end

    it 'is invalid with a duplicate month for the same user' do
      duplicate_report = build(:weekly_report, user:, start_date: weekly_report.start_date)
      expect(duplicate_report).to be_invalid
      expect(duplicate_report.errors[:start_date]).not_to be_empty
    end

    it 'is invalid without end_date' do
      report_without_end_date = build(:weekly_report, end_date: nil)
      expect(report_without_end_date).to be_invalid
      expect(report_without_end_date.errors[:end_date]).not_to be_empty
    end
  end
end
