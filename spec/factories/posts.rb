FactoryBot.define do
  sequence :end_date do |n|
    "2020-01-#{n}"
  end

  factory :post do
    book
    user
    title { 'reading' }
    active { true }
    end_date

    trait :invalid do
      title { nil }
    end

    trait :readed do
      title { 'reading' }
      active { false }
    end
  end
end
