class CustomerType < ApplicationRecord
  has_many :customer_records, dependent: :destroy
end
