require 'rails_helper'

RSpec.describe WeeklyTarget, type: :model do
  describe 'validation' do
    let(:user) { create(:user) }
    let(:weekly_target) { create(:weekly_target, user:) }
    before do
      weekly_target
    end

    it 'is valid with all attributes' do
      weekly_target = build(:weekly_target)
      expect(weekly_target).to be_valid
      expect(weekly_target.errors).to be_empty
    end

    it 'is invalid without target' do
      without_target = build(:weekly_target, target: nil)
      expect(without_target).to be_invalid
      expect(without_target.errors[:target]).not_to be_empty
    end

    it 'is invalid with target 0' do
      target_with_low = build(:weekly_target, target: 0)
      expect(target_with_low).to be_invalid
      expect(target_with_low.errors[:target]).not_to be_empty
    end

    it 'is invalid with target more than 2_000_000' do
      target_with_high = build(:weekly_target, target: 2_000_001)
      expect(target_with_high).to be_invalid
      expect(target_with_high.errors[:target]).not_to be_empty
    end

    it 'is invalid without start_date' do
      target_without_start_date = build(:weekly_target, start_date: nil)
      expect(target_without_start_date).to be_invalid
      expect(target_without_start_date.errors[:start_date]).not_to be_empty
    end

    it 'is invalid with a duplicate month for the same user' do
      duplicate_target = build(:weekly_target, user:, start_date: weekly_target.start_date)
      expect(duplicate_target).to be_invalid
      expect(duplicate_target.errors[:start_date]).not_to be_empty
    end

    it 'is invalid without end_date' do
      target_without_end_date = build(:weekly_target, end_date: nil)
      expect(target_without_end_date).to be_invalid
      expect(target_without_end_date.errors[:end_date]).not_to be_empty
    end
  end
end
