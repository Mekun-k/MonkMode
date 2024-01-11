class Answer < ApplicationRecord
  belongs_to :user
  has_many :child_answers, dependent: :destroy

  def self.score_create(answer)

    child_answers = answer.child_answers
    content = child_answers.map { |child_answers| child_answers.content }

    if content.count == 15
      success_result = content.count(true) * 1
      failure_result = content.count(false) * -1
      answer.score = success_result + failure_result
      answer.save!
    else
      is_error = true
    end

  end
end
