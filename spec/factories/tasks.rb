FactoryBot.define do
  factory :task do
    title { 'title' }
    is_group_task { true }
    deadline { Time.zone.today + 10.days }
    importance { 2 }
    is_completed { false }
    completed_by_id { nil }
    association :user
    association :group
  end
end
