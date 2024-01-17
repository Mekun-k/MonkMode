class Answer < ApplicationRecord
  belongs_to :user
  has_many :child_answers, dependent: :destroy
  has_many :favorites, dependent: :destroy

  NUMBERSET = 1

  MIN_NUMBER = 1
  SET_NUMBER = 2
  MAX_NUMBER = 16

  def favorited?(user)
    favorites.where(user_id: user.id).exists?
  end

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
