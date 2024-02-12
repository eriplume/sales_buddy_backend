class CustomerType < ApplicationRecord
  has_many :customer_records, dependent: :destroy

  validates :name, presence: true
end
