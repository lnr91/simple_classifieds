# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "nick_name#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    factory :admin do
      admin true
    end
  end

end
