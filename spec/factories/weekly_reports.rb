FactoryBot.define do
  factory :weekly_report do
    content { 'report' }
    sequence(:start_date) { |n| Time.zone.today.beginning_of_week + n.weeks }
    sequence(:end_date) { |n| Time.zone.today.end_of_week + n.weeks }
    association :user
  end
end
