require 'rails_helper'

RSpec.describe 'CustomerRecords', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  before do
    customer_types = create_list(:customer_type, 2)
    dairy_record = create(:dairy_record, user:)

    create(:customer_record, dairy_record:, customer_type: customer_types.first)
    create(:customer_record, dairy_record:, customer_type: customer_types.second)
  end

  describe 'GET /customer_records' do
    it '客層レコードの一覧を取得' do
      get '/customer_records', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(response.status).to eq(200)
      expect(json.length).to eq(2)
    end
  end
end
