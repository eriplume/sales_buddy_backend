class DairyRecordsController < ApplicationController
  def index
    user_id = request.headers['user']
    @dairy_records = DairyRecord.where(user_id: user_id)
    render json: @dairy_records
  end

  def create
    @dairy_record = DairyRecord.new(record_params)
            
    if @dairy_record.save
      if params[:dairy_record][:customers]
        customer_ids_counts = params[:dairy_record][:customers].tally
        # 渡ってくる配列[1, 2, 1]に対して
        # tally によって生成されるハッシュ { 1 => 2, 2 => 1 }
        customer_ids_counts.each do |customer_type_id, count|
        # 上のそれぞれを|customer_type_id, count|に割り当てる。それに対して下記の処理をする。
        customer_type = CustomerType.find(customer_type_id)
        # CustomerTypeテーブルの(customer_type_id)カラムから一致するものを探してそれを今回のcustomer_typeとする
        CustomerRecord.create(dairy_record: @dairy_record, customer_type: customer_type, count: count)
        end
      end
      
      render json: @dairy_record, status: :created
    else
      render json: @dairy_record.errors, status: :unprocessable_entity
    end
  end

  private
      
  def record_params
    params.require(:dairy_record).permit(:total_amount, :total_number, :count, :date, :user_id)
  end
end
