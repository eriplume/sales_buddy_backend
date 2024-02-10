class WeeklyReportsController < ApplicationController
  def index
    user_id = @current_user.id
    @weekly_reports = WeeklyReport.where(user_id:)
    render json: @weekly_reports.as_json(only: %i[content start_date end_date])
  end

  def create
    @weekly_report = @current_user.weekly_reports.new(report_params)
    if @weekly_report.save
      render json: { status: 'success' }
    else
      render json: @weekly_report.errors, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:weekly_report).permit(:content, :start_date, :end_date)
  end
end
