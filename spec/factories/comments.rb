FactoryBot.define do
  factory :comment do
    body { 'i am comment' }
    user
    book

    trait :invalid do
      body { nil }
    end
  end
end
