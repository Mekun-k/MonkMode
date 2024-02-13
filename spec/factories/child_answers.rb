FactoryBot.define do
  factory :child_answer do
    association :rule
    association :answer
    user { answer.user }
  end
end
