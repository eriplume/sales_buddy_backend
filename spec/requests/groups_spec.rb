require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  let(:token) { generate_token_for_user(user) }

  describe 'GET /groups' do
    let(:group) { create(:group) }
    let(:user) { create(:user, group:) }

    before do
      create_list(:user, 3, group:) # 同じグループに3人のユーザーを追加
    end

    it 'グループメンバー一覧を取得' do
      get '/groups', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(response.status).to eq(200)
      expect(json['members'].length).to eq(4)
    end
  end
end
