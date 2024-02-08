class MonthlyReportsController < ApplicationController
  before_action :set_monthly_report, only: [:update]

  def index
    user_id = @current_user.id
    @monthly_reports = MonthlyReport.where(user_id:)
    render json: @monthly_reports.as_json(only: %i[id content month])
  end

  def create
    @monthly_report = @current_user.monthly_reports.new(monthly_report_params)
    if @monthly_report.save
      render json: { status: 'success' }
    else
      render json: @monthly_report.errors, status: :unprocessable_entity
    end
  end

  def update
    if @monthly_report.update(update_report_params)
      render json: @monthly_report
    else
      render json: @monthly_report.errors, status: :unprocessable_entity
    end
  end

  private

  def monthly_report_params
    params.require(:monthly_report).permit(:content, :month)
  end

  def update_report_params
    params.require(:monthly_report).permit(:content)
  end

  def set_monthly_report
    @monthly_report = MonthlyReport.find(params[:id])
  end
end
