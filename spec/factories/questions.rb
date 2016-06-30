FactoryGirl.define do
  factory :question do
    title "MyQuestionMinimumLength"
    body "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod"
  end

  factory :invalid_question, class: "Question" do
    title "Invalid"
    body "Invalid"
  end
end
