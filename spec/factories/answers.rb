FactoryGirl.define do
  factory :answer do
    body "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod"
  end
  factory :invalid_answer, class: "Answer" do
    body "Invalid"
  end
end
