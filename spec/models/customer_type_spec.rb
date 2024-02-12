require 'rails_helper'

RSpec.describe CustomerType, type: :model do
  describe 'validation' do
    it 'is valid with all attributes' do
      customer_type = build(:customer_type)
      expect(customer_type).to be_valid
      expect(customer_type.errors).to be_empty
    end

    it 'is invalid without name' do
      without_name = build(:customer_type, name: nil)
      expect(without_name).to be_invalid
      expect(without_name.errors[:name]).not_to be_empty
    end
  end
end
