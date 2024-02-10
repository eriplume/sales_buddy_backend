FactoryBot.define do
  factory :job_record do
    association :job
    association :user
    sequence(:date) { |_n| Time.zone.today }
  end
end
