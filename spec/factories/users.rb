FactoryGirl.define do
  factory :user do
    email 'good_user@example.com'
    password '12345678'
  end

  factory :invalid_user, class: "User" do
    email 'bad_user@example.com'
    password '1234'
  end
end
