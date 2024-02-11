require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      group = build(:group)
      expect(group).to be_valid
      expect(group.errors).to be_empty
    end

    it 'is invalid without name' do
      group_without_name = build(:group, name: nil)
      expect(group_without_name).to be_invalid
      expect(group_without_name.errors[:name]).not_to be_empty
    end

    it 'is invalid without password' do
      group_without_password = build(:group, password: nil)
      expect(group_without_password).to be_invalid
      expect(group_without_password.errors[:password]).not_to be_empty
    end

    it 'is invalid with a duplicate name' do
      group = create(:group)
      duplicate_group = build(:group, name: group.name)
      expect(duplicate_group).to be_invalid
      expect(duplicate_group.errors[:name]).not_to be_empty
    end

    it 'is invalid with name more than 20 characters' do
      group_with_long_name = build(:group, name: 'a' * 21)
      expect(group_with_long_name).to be_invalid
      expect(group_with_long_name.errors[:name]).not_to be_empty
    end
  end
end
