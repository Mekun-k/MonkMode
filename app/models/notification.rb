class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :answer, optional: true
  belongs_to :comment, optional: true

  belongs_to :visitor, class_name: 'User', optional: true, inverse_of: :active_notifications
  belongs_to :visited, class_name: 'User', optional: true, inverse_of: :passive_notifications
end