class Contact < ApplicationRecord
  validates :name, presence: true
  validates :message, presence: true
end
