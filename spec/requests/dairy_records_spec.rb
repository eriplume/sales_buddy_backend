require 'rails_helper'

RSpec.describe 'DairyRecords', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  before do
    # factoriesで定義したテスト用のデータをセットアップ
    # userの作成
    create(:user)
  end

  describe 'GET /dairy_records' do
    before do
      # userに紐づく売上レコードを10件複製(配列)
      create_list(:dairy_record, 10, user:)
    end

    it '売上レコードの一覧を取得' do
      # エンドポイントへGETリクエスト
      get '/dairy_records', headers: { 'Authorization' => "Bearer #{token}" }
      # 返り値( render json: @daory_records)を変数に格納
      json = response.parsed_body

      # リクエスト成功を表す200が返ってきたか確認する。
      expect(response.status).to eq(200)
      # 10件のデータが返ってきているかを確認
      expect(json.length).to eq(10)
    end
  end

  describe 'Post /dairy_records' do
    before do
      # 客層タイプの作成
      @customer_type1 = CustomerType.create!(name: '主婦')
      @customer_type2 = CustomerType.create!(name: 'OL')
    end

    it '新しいタスクを作成する' do
      # リクエストで送られてくるテストデータ
      valid_params = {
        dairy_record: {
          total_amount: 50_000,
          total_number: 5,
          count: 2,
          date: Time.zone.today
        },
        customer_counts: { @customer_type1.id => 1, @customer_type2.id => 1 }
      }

      # エンドポイントへPOSTリクエスト→レコードが１増えるはず
      expect { post '/dairy_records', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
        .to change(DairyRecord, :count).by(+1)
                                       .and change(CustomerRecord, :count).by(2)

      expect(response.status).to eq(200)
    end
  end
end
