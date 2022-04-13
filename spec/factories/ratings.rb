FactoryBot.define do
  factory :rating do
    value { '3' }
    book
    user

    trait :invalid do
      value { nil }
    end
  end
end
