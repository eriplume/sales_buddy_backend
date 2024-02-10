FactoryBot.define do
  factory :job do
    sequence(:name) { |n| "job_#{n}" }
  end
end
