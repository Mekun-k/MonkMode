class Users::PasswordsController < Devise::PasswordsController
  before_action :ensure_normal_user, only: :create

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      redirect_to new_user_session_path, notice: "パスワードの再設定について数分以内にメールでご連絡いたします。"
    end
  end

  def ensure_normal_user
    if params[:user][:email].downcase == User::GUEST_USER_EMAIL
      redirect_to new_user_session_path, alert: 'ゲストユーザーのパスワード再設定はできません。'
    end
  end
end
