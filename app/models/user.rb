class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter facebook]

  GUEST_USER_EMAIL = 'guest@example.com'.freeze

  #パスワードなしでユーザー編集するためのメソッド
  has_many :sns_credential, dependent: :destroy

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  private

  # パスワードなしでユーザー編集するためのメソッド
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def self.guest
    find_or_create_by!(email: User::GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64(n = 10)
      user.name = "ゲスト"
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
