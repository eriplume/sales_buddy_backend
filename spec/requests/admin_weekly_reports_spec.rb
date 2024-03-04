require 'rails_helper'

RSpec.describe 'AdminWeeklyReports', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }
  let(:admin_user) { create(:user, :admin) }
  let(:admin_token) { generate_token_for_user(admin_user) }
  let(:weekly_reports) { create_list(:weekly_report, 3) }

  before do
    weekly_reports
  end

  describe 'GET /admin_weekly_reports' do
    context 'admin_userの場合' do
      it '週間レポートの一覧を取得' do
        get '/admin/weekly_reports', headers: { 'Authorization' => "Bearer #{admin_token}" }
        json = response.parsed_body

        expect(json['weekly_reports'].length).to eq(3)
        expect(response.status).to eq(200)
      end
    end

    context 'general_userの場合' do
      it '403エラーを返す' do
        get '/admin/weekly_reports', headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE /admin/weekly_reports/:id' do
    before do
      admin_user
      user
    end

    context 'admin_userの場合' do
      it '対象のレポートを削除する' do
        report = weekly_reports.first
        expect { delete "/admin/weekly_reports/#{report.id}", headers: { 'Authorization' => "Bearer #{admin_token}" } }
          .to change(WeeklyReport, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context 'general_userの場合' do
      it '403エラーを返す' do
        report = weekly_reports.first
        delete "/admin/weekly_reports/#{report.id}", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end
end
