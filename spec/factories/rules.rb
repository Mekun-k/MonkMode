FactoryBot.define do
  factory :rule do
    user { answer.user }
    rule_title { "test" }
    rule_content { "10" }
    rule_type_id { true }
  end
end

