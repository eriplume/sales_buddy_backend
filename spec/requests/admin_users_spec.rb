require 'rails_helper'

RSpec.describe 'AdminUsers', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }
  let(:admin_user) { create(:user, :admin) }
  let(:admin_token) { generate_token_for_user(admin_user) }

  describe 'GET /admin/users' do
    context 'admin_userの場合' do
      before do
        create_list(:user, 3)
      end
      it 'ユーザー一覧を取得' do
        get '/admin/users', headers: { 'Authorization' => "Bearer #{admin_token}" }
        json = response.parsed_body

        expect(json['users'].length).to eq(4)
        expect(response.status).to eq(200)
      end
    end

    context 'userの場合' do
      it '403エラーを返す' do
        get '/admin/users', headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH /admin/users/:id' do
    before do
      create(:user)
    end
    context 'admin_userの場合' do
      valid_params = { user: { role: 'admin' } }
      it 'ユーザーの権限を変更する' do
        patch "/admin/users/#{user.id}", headers: { 'Authorization' => "Bearer #{admin_token}" }, params: valid_params
        expect(user.reload.role).to eq(valid_params[:user][:role])
        expect(response.status).to eq(200)
      end
    end

    context 'userの場合' do
      it '403エラーを返す' do
        patch "/admin/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE /admin/users/:id' do
    context 'admin_userの場合' do
      before do
        admin_user
        user
      end
      it 'ユーザーを削除する' do
        expect { delete "/admin/users/#{user.id}", headers: { 'Authorization' => "Bearer #{admin_token}" } }
          .to change(User, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context 'userの場合' do
      it '403エラーを返す' do
        delete "/admin/users/#{user.id}", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end
end
