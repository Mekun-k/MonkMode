class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :answer

  validates :body, presence: true, length: { maximum: 1_000 }
end
