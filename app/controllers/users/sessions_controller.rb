class Users::SessionsController < Devise::SessionsController

  def guest_sign_in
    user = User.guest

    # 初期データを用意する際のメソッド

      Rule.rule_setteig(user)


    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました。'
  end

end
