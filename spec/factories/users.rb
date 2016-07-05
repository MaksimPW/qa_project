FactoryGirl.define do
  sequence :email do |n|
    'user#{n}@example.com'
  end
  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
  end

  factory :invalid_user, class: "User" do
    email 'bad_user@example.com'
    password '1234'
    password_confirmation '1234'
  end
end
