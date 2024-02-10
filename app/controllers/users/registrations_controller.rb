class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_account_update_params, only: [:update]
  before_action :ensure_normal_user, only: %i[update destroy]

  def new
    super
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザー認証メールを送信いたしました。認証が完了しましたらログインをお願いいたします。"
      redirect_to new_user_session_path
      Rule.rule_setting(@user)
    else
      flash.now[:error] = "ユーザー登録に失敗しました。"
      render action: :new and return
    end
  end

  def ensure_normal_user
    if resource.email == User::GUEST_USER_EMAIL
      redirect_to profile_path(current_user), alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(_resource)
    profile_path(current_user)
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :self_introduction])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :self_introduction)
  end
end
