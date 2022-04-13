FactoryBot.define do
  sequence :title do |n|
    "title_#{n}"
  end

  factory :book do
    title
    author { 'Pushkin' }
    description { 'description description description' }

    trait :invalid do
      title { nil }
      author { nil }
      description { 'invalid obj' }
    end

    factory :book_with_categories do
      transient do
        count { 5 }
      end

      after(:create) do |book, evaluator|
        create_list(:category, evaluator.count, books: [book])
      end
    end

    # trait :add_file do
    #   files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    # end
  end
end
