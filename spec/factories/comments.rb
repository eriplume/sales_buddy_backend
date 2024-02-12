FactoryBot.define do
  factory :comment do
    content { 'comment' }
    association :user
    association :task
  end
end
