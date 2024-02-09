require 'rails_helper'

RSpec.describe 'JobRecords', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_token_for_user(user) }

  describe 'GET /job_records' do
    before do
      jobs = create_list(:job, 2)
      create(:job_record, job: jobs.first, user:)
      create(:job_record, job: jobs.second, user:)
    end

    it '業務一覧を取得' do
      get '/job_records', headers: { 'Authorization' => "Bearer #{token}" }
      json = response.parsed_body

      expect(response.status).to eq(200)
      expect(json.length).to eq(2)
    end
  end

  describe 'POST /job_records' do
    before do
      create(:job, name: 'job_1')
      create(:job, name: 'job_2')
      create(:job, name: 'job_3')
    end

    context '既存のJobのみの場合' do
      it 'JobRecordが作成される' do
        valid_params = {
          job_record: {
            date: Time.zone.today,
            jobs: %w[job_1 job_2 job_3]
          }
        }
        expect { post '/job_records', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
          .to change(JobRecord, :count).by(+3)
        expect(response.status).to eq(200)
      end
    end

    context '既存のJob + 新規のJobの場合' do
      it 'JobRecord + 新規Jobが作成される' do
        valid_params = {
          job_record: {
            date: Time.zone.today,
            jobs: %w[job_1 job_2 job_4]
          }
        }
        expect { post '/job_records', headers: { 'Authorization' => "Bearer #{token}" }, params: valid_params }
          .to change(JobRecord, :count).by(+3)
          .and change(Job, :count).by(+1)
        expect(response.status).to eq(200)
      end
    end
  end
end
