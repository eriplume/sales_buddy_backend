FactoryBot.define do
  factory :user do
    name { 'tete' }
    sequence(:line_id) { |n| "line_id_#{n}" }
    image_url { nil }
    association :group
  end
end
