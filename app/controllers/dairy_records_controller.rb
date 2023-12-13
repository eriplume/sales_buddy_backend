class DairyRecordsController < ApplicationController
  def index
    user_id = request.headers['user']
    @dairy_records = DairyRecord.where(user_id: user_id)
    render json: @dairy_records
  end

  def create
    @dairy_record = DairyRecord.new(dairy_record_params)
    service = CustomerRecordCreateService.new(@dairy_record, params[:customer_counts])

    if service.call
      render json: {
        status: 'success', 
        dairy_record: { '登録する日': @dairy_record.date, '合計金額': @dairy_record.total_amount, 'セット率': @dairy_record.set_rate, '客単価': @dairy_record.average_spend }
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
