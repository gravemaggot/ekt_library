FactoryBot.define do
  sequence :email do |n|
    "user_#{n}@test.com"
  end

  factory :user do
    first_name { 'Ivan' }
    last_name { 'Ivanov' }
    email
    admin { 'false' }
    password { '12345678' }

    trait :invalid do
      first_name { nil }
      email { nil }
    end
  end
end
