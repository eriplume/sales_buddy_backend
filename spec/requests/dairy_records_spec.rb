require 'rails_helper'

RSpec.describe "DairyRecords", type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  describe "GET /dairy_records" do
    # factoriesで定義したテスト用のデータをセットアップ
    before do
      # userの作成/userに紐づく売上レコードを10件複製(配列)
      create(:user)
      create_list(:dairy_record, 10, user: user)
    end

    it "売上レコードの一覧を取得" do
      # エンドポイントへGETリクエスト
      get '/dairy_records', headers: { 'Authorization' => "Bearer #{token}" }
      # 返り値( render json: @daory_records)を変数に格納
      json = JSON.parse(response.body)

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
      # 10件のデータが返ってきているかを確認
      expect(json.length).to eq(10)
    end
  end
end