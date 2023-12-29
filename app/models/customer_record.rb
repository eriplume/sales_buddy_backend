class CustomerRecord < ApplicationRecord
  belongs_to :dairy_record
  belongs_to :customer_type

  def self.summary_by_user(user_id)
    CustomerRecord.joins(:dairy_record)
                  .where(dairy_records: { user_id: user_id })
                  .group(:customer_type_id)
                  .sum(:count)
  end
end
