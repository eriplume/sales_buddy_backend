FactoryBot.define do
  factory :dairy_record do
    total_amount { 50_000 }
    total_number { 5 }
    count { 2 }
    set_rate { 2.5 }
    average_spend { 10_000 }
    sequence(:date) { |n| Time.zone.today - n.days }
    association :user
  end
end
