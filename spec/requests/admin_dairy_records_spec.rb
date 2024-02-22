require 'rails_helper'

RSpec.describe 'AdminDairyRecords', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }
  let(:admin_user) { create(:user, :admin) }
  let(:admin_token) { generate_token_for_user(admin_user) }
  let(:dairy_records) { create_list(:dairy_record, 10) }

  before do
    dairy_records
  end

  describe 'GET /admin/dairy_records' do
    context 'admin_userの場合' do
      it '売上レコード一覧を取得' do
        get '/admin/dairy_records', headers: { 'Authorization' => "Bearer #{admin_token}" }
        json = response.parsed_body

        expect(json['dairy_records'].length).to eq(10)
        expect(response.status).to eq(200)
      end
    end

    context 'general_userの場合' do
      it '403エラーを返す' do
        get '/admin/dairy_records', headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE /admin/dairy_records/:id' do
    before do
      user
      admin_user
    end

    context 'admin_userの場合' do
      it '売上レコードを削除する' do
        record = dairy_records.first
        expect { delete "/admin/dairy_records/#{record.id}", headers: { 'Authorization' => "Bearer #{admin_token}" } }
          .to change(DairyRecord, :count).by(-1)
        expect(response.status).to eq(204)
      end
    end

    context 'general_userの場合' do
      it '403エラーを返す' do
        record = dairy_records.first
        delete "/admin/dairy_records/#{record.id}", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response.status).to eq(403)
      end
    end
  end
end
