class JobRecordsController < ApplicationController
  def index
    user_id = request.headers['user']
    @job_records = JobRecord.includes(:job).where(user_id:)
    render json: @job_records.map { |record|
      {
        job: record.job.name,
        date: record.date
      }
    }
  end

  def create
    form_data = job_record_params
    date = form_data[:date]
    user_id = form_data[:user_id]
    job_names = form_data[:jobs]

    if JobRecord.create_from_job_names(user_id, date, job_names)
      render json: { status: 'success' }
    else
      render json: { error: 'Failed to create job records' }, status: :unprocessable_entity
    end
  end

  private

  def job_record_params
    params.require(:job_record).permit(:date, :user_id, jobs: [])
  end
end
