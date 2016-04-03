FactoryGirl.define do
  factory :visitor, class: User do
    email "visitor@ait.asia"
    password "password"
    password_confirmation "password"
  end
end