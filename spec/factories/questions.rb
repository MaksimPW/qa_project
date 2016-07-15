FactoryGirl.define do
  sequence :title do |n|
    "MyQuestion№#{n}MinimumLength"
  end

  factory :question do |q|
    title
    q.sequence(:body) { |n| "Lorem ipsum dolors №#{n} sit amet, consectetur adipisicing elit, sed do eiusmod" }
    user
  end

  factory :invalid_question, class: "Question" do
    title "Invalid"
    body "Invalid"
  end
end
