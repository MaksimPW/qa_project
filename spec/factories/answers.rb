FactoryGirl.define do
  sequence :body do |n|
    "#{(0...32).map { (65 + rand(26)).chr }.join}"
  end

  factory :answer do
    body
    user
    question
  end

  factory :invalid_answer, class: "Answer" do
    body "Invalid"
  end
end
