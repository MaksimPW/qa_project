FactoryGirl.define do
  factory :comment do |c|
    c.sequence(:body) { "#{(0...16).map { (65 + rand(26)).chr }.join}" }
    user
  end

  factory :invalid_comment, class: "Comment" do
    body ''
    user
  end
end
