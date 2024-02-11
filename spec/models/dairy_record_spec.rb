require 'rails_helper'

RSpec.describe DairyRecord, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:dairy_record) { create(:dairy_record, user:) }

    before do
      dairy_record
    end
    it 'is valid with all attributes' do # すべてのバリデーションをクリア
      dairy_record = build(:dairy_record)
      expect(dairy_record).to be_valid
      expect(dairy_record.errors).to be_empty
    end

    it 'is invalid without total_amount' do
      without_total_amount = build(:dairy_record, total_amount: nil)
      expect(without_total_amount).to be_invalid
      expect(without_total_amount.errors[:total_amount]).not_to be_empty
    end

    it 'is invalid without total_number' do
      without_total_number = build(:dairy_record, total_number: nil)
      expect(without_total_number).to be_invalid
      expect(without_total_number.errors[:total_number]).not_to be_empty
    end

    it 'is invalid without count' do
      without_count = build(:dairy_record, count: nil)
      expect(without_count).to be_invalid
      expect(without_count.errors[:count]).not_to be_empty
    end

    it 'is invalid without date' do
      without_date = build(:dairy_record, date: nil)
      expect(without_date).to be_invalid
      expect(without_date.errors[:date]).not_to be_empty
    end

    it 'is invalid with a duplicate date for the same user' do
      duplicate_record = build(:dairy_record, user:, date: dairy_record.date)
      expect(duplicate_record).to be_invalid
      expect(duplicate_record.errors[:date]).not_to be_empty
    end
  end

  describe 'calculate_metrics' do
    it 'correctly calculates set_rate, average_spend before saving' do
      dairy_record = build(:dairy_record, total_amount: 100, total_number: 10, count: 2)
      dairy_record.save
      expect(dairy_record.set_rate).to eq(5.0) # 10 / 2
      expect(dairy_record.average_spend).to eq(10.0) # 100 / 10
    end
  end
end
