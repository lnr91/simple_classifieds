# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    trait :subcategory do
      sequence(:name) { |n| "Subategory #{n}" }
      parent_category :category
    end

    factory :subcategory, traits: [:subcategory]
  end

end
