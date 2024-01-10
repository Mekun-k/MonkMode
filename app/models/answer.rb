class Answer < ApplicationRecord
  belongs_to :user
  has_many :child_answers, dependent: :destroy
end
