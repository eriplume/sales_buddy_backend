require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /users/current' do
    context 'ユーザーがグループに所属している場合' do
      let(:group) { create(:group) }
      let(:user) { create(:user, group:) }
      let(:token) { generate_token_for_user(user) }

      it 'ユーザーの詳細を返す(グループIDが含まれる)' do
        get '/users/current', headers: { 'Authorization' => "Bearer #{token}" }
        json = response.parsed_body

        expect(json['group_id']).to eq(group.id)
        expect(response.status).to eq(200)
      end
    end

    context 'ユーザーがグループに所属していない場合' do
      let(:user) { create(:user) }
      let(:token) { generate_token_for_user(user) }

      it 'ユーザーの詳細を返す(グループIDがnil)' do
        get '/users/current', headers: { 'Authorization' => "Bearer #{token}" }
        json = response.parsed_body

        expect(json['group_id']).to eq(nil)
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'PATCH /users/**' do
    let(:group) { create(:group) }
    let(:user) { create(:user, group:) }
    let(:token) { generate_token_for_user(user) }

    context 'update_notifications' do
      valid_params = { user: { notifications: true } }
      it '通知設定を切り替える' do
        patch '/users/update_notifications', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params
        expect(user.reload.notifications).to eq(valid_params[:user][:notifications])
        expect(response.status).to eq(200)
      end
    end

    context 'update_task_notifications' do
      valid_params = { user: { task_notifications: true } }
      it 'タスク通知設定を切り替える' do
        patch '/users/update_task_notifications', headers: { 'Authorization' => "Bearer #{token}" },
                                                  params: valid_params
        expect(user.reload.task_notifications).to eq(valid_params[:user][:task_notifications])
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'GET /users/admin_status' do
    let(:user) { create(:user) }
    let(:token) { generate_token_for_user(user) }
    it 'ユーザー権限を返す' do
      get '/users/admin_status', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(json['admin']).to eq(false)
      expect(response.status).to eq(200)
    end
  end
end
