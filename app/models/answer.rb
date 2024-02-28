class Answer < ApplicationRecord
  belongs_to :user
  has_many :child_answers, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  NUMBERSET = 1

  MIN_NUMBER = 1
  SET_NUMBER = 2
  MAX_NUMBER = 16
  HASH_MAX_NUMBER = 15

  def create_notification_favorite!(current_user)
    notification_favorite = Notification.where(["visitor_id = ? and visited_id = ? and answer_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    if notification_favorite.blank?
      notification = current_user.active_notifications.new(
        answer_id: id,
        visited_id: user_id,
        action: 'favorite'
      )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    notification_comment = Comment.select(:user_id).where(answer_id: id).where.not(user_id: current_user.id).distinct
    notification_comment.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if notification_comment.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      answer_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def commented?(user)
    comments.where(user_id: user.id).exists?
  end

  def favorited?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.score_create(answer)
    child_answers = answer.child_answers
    content = child_answers.pluck(:content)

    if content.count == Answer::HASH_MAX_NUMBER
      success_result = content.count(true) * NUMBERSET
      answer.score = success_result
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
