class ApplicationController < ActionController::Base

  private

  #ログイン後の遷移先
  def after_sign_in_path_for(resource_or_scope)
    root_path
  end

  #ログアウト後の遷移先
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
