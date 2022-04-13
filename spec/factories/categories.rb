FactoryBot.define do
  sequence :name do |n|
    "category_name_#{n}"
  end

  factory :category do
    title { generate(:name) }

    trait :invalid do
      title { nil }
    end
  end
end
