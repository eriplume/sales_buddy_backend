class CustomerRecordCreateService
  def initialize(dairy_record, customer_counts)
    @dairy_record = dairy_record
    @customer_counts = customer_counts
  end

  def call
    ActiveRecord::Base.transaction do
      @dairy_record.save!
      @customer_counts.each do |customer_type_id, count|
        customer_type = CustomerType.find(customer_type_id)
        CustomerRecord.create!(dairy_record: @dairy_record, customer_type:, count:)
      end
    end
  end
end
