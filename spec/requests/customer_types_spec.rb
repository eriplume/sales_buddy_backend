require 'rails_helper'

RSpec.describe 'CustomerTypes', type: :request do
  before do
    create_list(:customer_type, 5)
  end

  describe 'GET /customer_types' do
    it '客層タイプ一覧を取得' do
      get '/customer_types'
      json = response.parsed_body

      expect(json.length).to eq(5)
      expect(response.status).to eq(200)
    end
  end
end
