require 'rails_helper'

RSpec.describe 'MonthlyReports', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  before do
    create(:user)
  end

  describe 'GET /monthly_reports' do
    before do
      create_list(:monthly_report, 5, user:)
    end

    it '月間レポートの一覧を取得' do
      get '/monthly_reports', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end
  end

  describe 'POST /monthly_reports' do
    it '月間レポートを登録する' do
      valid_params = {
        monthly_report: {
          content: 'report_content',
          month: '2014-01'
        }
      }
      expect { post '/monthly_reports', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
        .to change(MonthlyReport, :count).by(+1)
      expect(response.status).to eq(200)
    end
  end
end
