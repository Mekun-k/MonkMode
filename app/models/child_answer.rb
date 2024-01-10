class ChildAnswer < ApplicationRecord
  belongs_to :user
  belongs_to :rule
  belongs_to :answer

  def self.answer_setting(user, answer, rule_id, value)
    ChildAnswer.create(
      user_id: user.id,
      answer_id: answer.id,
      rule_id: rule_id,
      contnet: value
    )
  end
end
