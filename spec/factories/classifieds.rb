# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :classified do
    sequence(:name) {|n| "Classified #{n}"}
    sequence(:description) {|n| "Classified Description #{n}"}
    price 1500
    category
    user
  end
end
