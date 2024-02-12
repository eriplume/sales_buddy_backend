require 'rails_helper'

RSpec.describe CustomerRecord, type: :model do
  describe '.summary_by_user' do
    let(:user) { create(:user) }
    let(:customer_type1) { create(:customer_type) }
    let(:customer_type2) { create(:customer_type) }

    before do
      # userに関連するCustomerRecordのみを作成
      create(:customer_record, customer_type: customer_type1, dairy_record: create(:dairy_record, user:), count: 5)
      create(:customer_record, customer_type: customer_type1, dairy_record: create(:dairy_record, user:), count: 3)
      create(:customer_record, customer_type: customer_type2, dairy_record: create(:dairy_record, user:), count: 2)
    end

    it 'returns the correct summary by user' do
      summary = CustomerRecord.summary_by_user(user.id)
      expect(summary[customer_type1.id]).to eq(8) # customer_type1に対するcountの合計 (5 + 3)
      expect(summary[customer_type2.id]).to eq(2) # customer_type2に対するcount
    end
  end
end
