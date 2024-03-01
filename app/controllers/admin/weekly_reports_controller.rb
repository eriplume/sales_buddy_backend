module Admin
  class WeeklyReportsController < BaseController
    def index
      weekly_reports = WeeklyReport.order(:id)
      render json: { weekly_reports: transform_weekly_reports(weekly_reports) }
    end

    def destroy
      weekly_report = WeeklyReport.find(params[:id])
      weekly_report.destroy!
    end

    private

    def transform_weekly_reports(weekly_reports)
      weekly_reports.map do |weekly_report|
        weekly_report.as_json.transform_keys { |key| key.to_s.camelize(:lower) }
      end
    end
  end
end
