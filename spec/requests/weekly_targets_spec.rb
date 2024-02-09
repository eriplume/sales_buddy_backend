require 'rails_helper'

RSpec.describe 'WeeklyTargets', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  before do
    create(:user)
  end

  describe 'GET /weekly_targets' do
    before do
      create_list(:weekly_target, 5, user:)
    end

    it '週間目標一覧を取得' do
      get '/weekly_targets', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(response.status).to eq(200)
      expect(json.length).to eq(5)
    end
  end

  describe 'POST /weekly_targets' do
    it '週間目標を登録' do
      valid_params = {
        weekly_target: {
          target: 100_000,
          start_date: Time.zone.today.beginning_of_week,
          end_date: Time.zone.today.end_of_week
        }
      }
      expect { post '/weekly_targets', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
        .to change(WeeklyTarget, :count).by(+1)
      expect(response.status).to eq(200)
    end
  end
end
