class JobRecordsController < ApplicationController
  def index
    user_id = request.headers['user']
    @job_records = JobRecord.includes(:job).where(user_id: user_id)
    render json: @job_records.map { |record|
      {
        job: record.job.name,
        date: record.date
      }
    }
  end
    
  def create
    @job_record = JobRecord.new(job_record_params)
    if @job_record.save
      render json: { status: 'success' }
    else
      render json: @job_record.errors, status: :unprocessable_entity
    end
  end
    
  private
    
  def job_record_params
    params.require(:job_record).permit(:date, :job, :user_id)
  end
end
