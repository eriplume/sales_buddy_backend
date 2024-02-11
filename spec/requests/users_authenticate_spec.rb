require 'rails_helper'

RSpec.describe 'POST /users/authenticate', type: :request do
  let(:valid_api_token) { 'api_token_for_test' } # テスト用のトークン
  let(:test_secret_key) { 'secret_key_for_test' }
  let(:valid_params) do
    {
      user: {
        line_id: 'line_id1234',
        name: 'test_name',
        image_url: 'nil'
      }
    }
  end

  before do
    allow(ENV).to receive(:fetch).with('API_TOKEN', nil).and_return(valid_api_token)
  end

  describe 'リクエストに正しいAPIトークンが付与されている場合' do
    before do
      allow(ENV).to receive(:fetch).with('SECRET_KEY_BASE', nil).and_return(test_secret_key)
    end

    context '初回アクセスの場合' do
      it '新規ユーザーを登録し、アクセストークンとユーザーIDを返す' do
        expect do
          post '/users/authenticate', headers: { 'Authorization' => "Bearer #{valid_api_token}" }, params: valid_params
        end
          .to change(User, :count).by(+1)

        json = response.parsed_body

        expect(json['user']).to include('token', 'user_id')
        expect(response.status).to eq(200)
      end
    end

    context '２回目以降のアクセスの場合' do
      let(:user) { create(:user) }
      let(:existing_user_params) do
        {
          user: {
            name: user.name,
            line_id: user.line_id,
            image_url: user.image_url
          }
        }
      end

      before do
        user
      end

      it 'アクセストークンとユーザーIDを返す' do
        expect do
          post '/users/authenticate', headers: { 'Authorization' => "Bearer #{valid_api_token}" },
                                      params: existing_user_params
        end
          .not_to change(User, :count)

        json = response.parsed_body

        expect(json['user']).to include('token', 'user_id')
        expect(response.status).to eq(200)
      end
    end

    context '2回目以降のアクセスで、プロフィール情報が変わっている場合' do
      let(:user) { create(:user) }
      let(:update_user_params) do
        {
          user: {
            name: 'new_user_name',
            line_id: user.line_id,
            image_url: 'new_image_url'
          }
        }
      end

      before do
        user
      end

      it 'ユーザー情報を更新し、アクセストークンとユーザーIDを返す' do
        expect do
          post '/users/authenticate', headers: { 'Authorization' => "Bearer #{valid_api_token}" },
                                      params: update_user_params
        end
          .not_to change(User, :count)

        json = response.parsed_body

        expect(user.reload.name).to eq(update_user_params[:user][:name])
        expect(json['user']).to include('token', 'user_id')
        expect(response.status).to eq(200)
      end
    end
  end

  describe '受け取ったAPIトークンが一致しない場合' do
    let(:invalid_api_token) { 'invalid_api_token' }
    it '登録、および更新に失敗し401エラーを返す' do
      expect do
        post '/users/authenticate', headers: { 'Authorization' => "Bearer #{invalid_api_token}" }, params: valid_params
      end
        .not_to change(User, :count)
      expect(response.status).to eq(401)
    end
  end

  describe 'APIトークンが付与されていない場合' do
    it '登録、および更新に失敗し401エラーを返す' do
      expect { post '/users/authenticate', params: valid_params }
        .not_to change(User, :count)
      expect(response.status).to eq(401)
    end
  end
end
