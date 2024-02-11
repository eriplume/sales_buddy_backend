require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  let(:group) { create(:group) }
  let(:user) { create(:user, group:) }
  let(:token) { generate_token_for_user(user) }

  describe 'GET /groups' do
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

  describe 'POST /groups' do
    before do
      user
    end

    context 'DBに登録されていないグループ名を受け取った場合' do
      it '新しいグループを作成し、userの所属グループを更新する' do
        valid_params = {
          group: {
            name: 'new_group',
            password: 'password'
          }
        }
        expect { post '/groups', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
          .to change(Group, :count).by(+1) # groupが１増える

        new_group = Group.find_by(name: 'new_group')
        expect(new_group).not_to be_nil

        user.reload # ユーザーオブジェクトを最新の状態に更新
        expect(user.group_id).to eq(new_group.id)
        expect(response.status).to eq(200)
      end
    end

    context 'DBに既に登録されているグループ名を受け取った場合' do
      before do
        create(:group, name: 'existing_group', password: 'password')
      end

      it 'グループ作成に失敗しエラーを返す' do
        invalid_params = {
          group: {
            name: 'existing_group',
            password: 'password'
          }
        }
        expect { post '/groups', headers: { 'Authorization' => "Bearer #{token}" }, params: invalid_params }
          .not_to change(Group, :count)

        user.reload
        expect(user.group.name).to eq(group.name) # group名は変わらない
        expect(response.status).to eq(422)
      end
    end
  end
end
