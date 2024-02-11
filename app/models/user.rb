class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter facebook]

  has_many :sns_credentials, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :child_answers, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  has_one_attached :avatar

  validates :self_introduction, length: { maximum: 140 }
  validates :email, presence: true
  validates :name, presence: true


  def map(user)
    answers = user.answers
    answer_created = answers.pluck(:created_at)
    answer_created_at = answer_created.map { |a| a.to_i }
    answer_score = answers.pluck(:score)
    heatmap_value = Hash[answer_created_at.zip(answer_score)]
  end

  def own?(object)
    object.user_id == id
  end

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  GUEST_USER_EMAIL = 'guest@example.com'.freeze

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  private

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def self.guest
    find_or_create_by!(email: User::GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64(n = 10)
      user.name = "ゲスト"
      user.self_introduction = "閲覧用のアカウントです"
      user.confirmed_at = Time.now
    end
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token(10)
      user.skip_confirmation!
    end
  end
end
