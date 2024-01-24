class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :answer
  has_many :notifications, dependent: :destroy

  validates :body, presence: true, length: { maximum: 1_000 }
end
