FactoryBot.define do
  factory :favorite do
    association :answer
    user { answer.user }
  end
end
