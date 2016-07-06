FactoryGirl.define do
  sequence :body do |n|
    "Valid Answer №#{n} : But I must explain to you how all this mistaken idea of"
  end

  factory :answer do
    body
  end

  factory :invalid_answer, class: "Answer" do
    body "Invalid"
  end
end
