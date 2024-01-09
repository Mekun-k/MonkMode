class Users::SessionsController < Devise::SessionsController

  def guest_sign_in
    user = User.guest
    Rule.rule?(user)
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

end
