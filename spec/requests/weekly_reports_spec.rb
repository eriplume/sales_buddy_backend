require 'rails_helper'

RSpec.describe 'WeeklyReports', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  describe 'GET /weekly_reports' do
    before do
      create_list(:weekly_report, 5, user:)
    end

    it '週間レポート一覧を取得' do
      get '/weekly_reports', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end
  end

  describe 'POST /weekly_reports' do
    it '週間レポートを作成' do
      valid_params = {
        weekly_report: {
          content: 'report_content',
          start_date: Time.zone.today.beginning_of_week,
          end_date: Time.zone.today.end_of_week
        }
      }
      expect { post '/weekly_reports', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
        .to change(WeeklyReport, :count).by(+1)
      expect(response.status).to eq(200)
    end
  end
end
