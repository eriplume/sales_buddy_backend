require 'rails_helper'

RSpec.describe 'GroupMemberships', type: :request do
  let(:group) { create(:group) }
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  before do
    group
    user
  end

  describe 'POST /groups/join' do
    context '正しいグループ名とパスワードを受け取る' do
      it 'ユーザーの所属グループを更新する' do
        valid_params = {
          group: {
            name: 'group_name',
            password: 'password'
          }
        }
        post '/groups/join', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params
        expect(user.reload.group.id).to eq(group.id)
        expect(response.status).to eq(200)
      end
    end

    context 'DBにグループ名が存在しない場合' do
      it '404エラーを返す' do
        invalid_params = {
          group: {
            name: 'not_found_group',
            password: 'password'
          }
        }
        post '/groups/join', headers: { 'Authorization' => "Bearer #{token}" }, params: invalid_params
        expect(response.status).to eq(404)
      end
    end

    context 'passwordが誤っている場合' do
      it '422エラーを返す' do
        invalid_params = {
          group: {
            name: 'group_name',
            password: 'mistaken_password'
          }
        }
        post '/groups/join', headers: { 'Authorization' => "Bearer #{token}" }, params: invalid_params
        expect(response.status).to eq(422)
      end
    end
  end
end
