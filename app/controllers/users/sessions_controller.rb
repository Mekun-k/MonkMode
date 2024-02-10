class Users::SessionsController < Devise::SessionsController

  def guest_sign_in
    user = User.guest
    Rule.rule?(user)
    sign_in user
    redirect_to profile_path(user), notice: 'ゲストユーザーとしてログインしました。'
  end

end
