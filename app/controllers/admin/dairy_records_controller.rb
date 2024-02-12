module Admin
  class DairyRecordsController < BaseController
    def index
      dairy_records = DairyRecord.order(:id)
      render json: { dairy_records: transform_dairy_records(dairy_records) }
    end

    def destroy
      dairy_records = DairyRecord.find(params[:id])
      dairy_records.destroy!
    end

    private

    def transform_dairy_records(dairy_records)
      dairy_records.map do |dairy_record|
        dairy_record.as_json.transform_keys { |key| key.to_s.camelize(:lower) }
      end
    end
  end
end
