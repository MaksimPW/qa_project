FactoryGirl.define do
  factory :answer do
    body "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and"
  end
  factory :invalid_answer, class: "Answer" do
    body "Invalid"
  end
end
