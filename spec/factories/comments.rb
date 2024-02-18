FactoryBot.define do
  factory :comment do
    association :answer
    user { answer.user }
    body { "test_comment" }
  end
end
