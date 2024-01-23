class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, followed.id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: followed.id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end
