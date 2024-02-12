FactoryBot.define do
  factory :user do
    name { 'name' }
    sequence(:line_id) { |n| "line_id_#{n}" }
    image_url { nil }

    trait :admin do
      role { 2 }
    end
  end
end
