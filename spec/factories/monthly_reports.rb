FactoryBot.define do
  factory :monthly_report do
    content { 'report' }
    sequence(:month) { |n| "2024-0#{n}" }
    association :user
  end
end
