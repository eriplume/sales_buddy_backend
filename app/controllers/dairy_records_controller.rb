class DairyRecordsController < ApplicationController
  def index
    user_id = request.headers['user']
    @dairy_records = DairyRecord.where(user_id:).order(:date)
    render json: @dairy_records.as_json(only: %i[average_spend count date set_rate total_amount total_number])
  end

  def create
    @dairy_record = DairyRecord.new(dairy_record_params)
    service = CustomerRecordCreateService.new(@dairy_record, params[:customer_counts])

    if service.call
      render json: {
        status: 'success',
        dairy_record: { date: @dairy_record.date }
      }
    else
      render json: @dairy_record.errors, status: :unprocessable_entity
    end
  end

  private

  def dairy_record_params
    params.require(:dairy_record).permit(:total_amount, :total_number, :count, :date, :user_id)
  end
end
