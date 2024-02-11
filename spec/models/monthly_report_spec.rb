require 'rails_helper'

RSpec.describe MonthlyReport, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:monthly_report) { create(:monthly_report, user:) }
    before do
      monthly_report
    end

    it 'is valid with all attributes' do
      monthly_report = build(:monthly_report)
      expect(monthly_report).to be_valid
      expect(monthly_report.errors).to be_empty
    end

    it 'is invalid without content' do
      report_without_content = build(:monthly_report, content: nil)
      expect(report_without_content).to be_invalid
      expect(report_without_content.errors[:content]).not_to be_empty
    end

    it 'is invalid without month' do
      report_without_month = build(:monthly_report, month: nil)
      expect(report_without_month).to be_invalid
      expect(report_without_month.errors[:month]).not_to be_empty
    end

    it 'is invalid with a duplicate month for the same user' do
      duplicate_report = build(:monthly_report, user:, month: monthly_report.month)
      expect(duplicate_report).to be_invalid
      expect(duplicate_report.errors[:month]).not_to be_empty
    end
  end
end
