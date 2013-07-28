# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    from_id 1
    to_id 1
    content "MyString"
    classified
  end
end
