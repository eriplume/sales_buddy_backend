class CustomerRecord < ApplicationRecord
  belongs_to :dairy_record
  belongs_to :customer_type
end
