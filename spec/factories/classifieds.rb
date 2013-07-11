# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :classified do
    name "MyString"
    description "MyString"
    price 1
    category_id 1
  end
end
