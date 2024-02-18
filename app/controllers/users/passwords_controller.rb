class Users::PasswordsController < Devise::PasswordsController
  before_action :ensure_normal_user, only: :create

  def create # rubocop:disable Lint/UselessMethodDefinition
    super
  end

  def ensure_normal_user
    if params[:user][:email].downcase == User::GUEST_USER_EMAIL
      redirect_to new_user_session_path, alert: 'ゲストユーザーのパスワード再設定はできません。'
    end
  end
end
