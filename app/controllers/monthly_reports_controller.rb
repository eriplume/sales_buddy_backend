class MonthlyReportsController < ApplicationController
  def index
    user_id = request.headers['user']
    @monthly_reports = MonthlyReport.where(user_id:)
    render json: @monthly_reports.as_json(only: %i[content month])
  end
    
  def create
    @monthly_report = MonthlyReport.new(report_params)
    if @monthly_report.save
      render json: { status: 'success' }
    else
      render json: @monthly_report.errors, status: :unprocessable_entity
    end
  end
    
  private
    
  def report_params
    params.require(:monthly_report).permit(:content, :month, :user_id)
  end
end
