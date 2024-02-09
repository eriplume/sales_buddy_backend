FactoryBot.define do
  factory :customer_record do
    count { 1 }
    association :dairy_record
    association :customer_type
  end
end
