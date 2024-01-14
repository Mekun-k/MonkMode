class Answer < ApplicationRecord
  belongs_to :user
  has_many :child_answers, dependent: :destroy

  NUMBERSET = 1

  MIN_NMBER = 1
  SET_NMBER = 2
  MAX_NMBER = 16

  def self.score_create(answer)
    child_answers = answer.child_answers
    content = child_answers.pluck(:content)

    if content.count == 15
      success_result = content.count(true) * NUMBERSET
      failure_result = content.count(false) * -NUMBERSET
      answer.score = success_result + failure_result
      answer.save
    else
      is_error = true
    end
  end

  def self.success_result(answer)
    child_answers = answer.child_answers
    content = child_answers.pluck(:content)
    result = content.count(true) * NUMBERSET
  end
end
