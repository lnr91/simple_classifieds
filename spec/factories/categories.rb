# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name) {|n| "Category #{n}" }
  end

  factory :subcategory do
    sequence(:name) {|n| "Subcategory #{n}" }
    category
  end
end
