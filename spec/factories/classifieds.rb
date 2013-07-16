# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :classified do
    sequence(:name) {|n| "Classified #{n}"}
    sequence(:description) {|n| "Classified Description #{n}"}
    price rand(100..30000)
    category
  end
end
