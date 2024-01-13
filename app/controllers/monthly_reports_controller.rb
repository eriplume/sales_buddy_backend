class MonthlyReportsController < ApplicationController
  before_action :set_monthly_report, only: [:update]

  def index
    user_id = @current_user.id
    @monthly_reports = MonthlyReport.where(user_id:)
    render json: @monthly_reports.as_json(only: %i[id content month])
  end

  def create
    @monthly_report = MonthlyReport.new(report_params)
    if @monthly_report.save
      render json: { status: 'success' }
    else
      render json: @monthly_report.errors, status: :unprocessable_entity
    end
  end

  def update
    if @monthly_report.update(monthly_report_params)
      render json: @monthly_report
    else
      render json: @monthly_report.errors, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:monthly_report).permit(:content, :month, :user_id)
  end

  def monthly_report_params
    params.require(:monthly_report).permit(:content, :id)
  end

  def set_monthly_report
    @monthly_report = MonthlyReport.find(params[:id])
  end
end
