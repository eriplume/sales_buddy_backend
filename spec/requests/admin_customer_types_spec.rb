require 'rails_helper'

RSpec.describe 'AdminCustomerTypes', type: :request do
  let(:customer_types) { create_list(:customer_type, 7) }
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }
  let(:admin_user) { create(:user, :admin) }
  let(:admin_token) { generate_token_for_user(admin_user) }

  before do
    customer_types
  end

  describe 'GET /admin_customer_types' do
    context 'admin_userの場合' do
      it '客層タイプの一覧を取得' do
        get '/admin/customer_types', headers: { 'Authorization' => "Bearer #{admin_token}" }
        json = response.parsed_body

        expect(json['customer_types'].length).to eq(7)
        expect(response.status).to eq(200)
      end
    end

    context 'general_userの場合' do
      it '403エラーを返す' do
        get '/admin/customer_types', headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'POST /admin/customer_types' do
    context 'admin_userの場合' do
      valid_params = { customer_type: { name: 'new_customer' } }
      it '新しい客層タイプを作成する' do
        expect do
          post '/admin/customer_types', headers: { 'Authorization' => "Bearer #{admin_token}" }, params: valid_params
        end
          .to change(CustomerType, :count).by(+1)
        expect(response.status).to eq(200)
      end
    end

    context 'general_userの場合' do
      valid_params = { customer_type: { name: 'new_customer' } }
      it '403エラーを返す' do
        expect { post '/admin/customer_types', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
          .not_to change(CustomerType, :count)
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'PATCH /admin/customer_types/:id' do
    context 'admin_userの場合' do
      valid_params = { customer_type: { name: 'update_name' } }
      it '客層タイプ名を更新する' do
        customer_type1 = customer_types.first
        patch "/admin/customer_types/#{customer_type1.id}", headers: { 'Authorization' => "Bearer #{admin_token}" },
                                                            params: valid_params
        expect(customer_type1.reload.name).to eq(valid_params[:customer_type][:name])
        expect(response.status).to eq(200)
      end
    end

    context 'general_userの場合' do
      it '403エラーを返す' do
        customer_type1 = customer_types.first
        patch "/admin/customer_types/#{customer_type1.id}", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE /admin/customer_types/:id' do
    context 'admin_userの場合' do
      before do
        admin_user
        user
      end
      it '客層タイプ削除する' do
        customer_type1 = customer_types.first
        expect do
          delete "/admin/customer_types/#{customer_type1.id}", headers: { 'Authorization' => "Bearer #{admin_token}" }
        end
          .to change(CustomerType, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context 'general_userの場合' do
      it '403エラーを返す' do
        customer_type1 = customer_types.first
        delete "/admin/customer_types/#{customer_type1.id}", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end
end
