class ApplicationController < ActionController::Base
before_action :configure_permitted_parameters, if: :devise_controller?
add_flash_types :success, :info, :warning, :danger

  protected

  #ユーザー登録時、任意のカラムを登録できる設定
  def configure_permitted_parameters
    added_attrs = [ :email, :password, :password_confirmation, :name, :avatar ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end

  private

  #ログイン後の遷移先
  def after_sign_in_path_for(resource_or_scope)
    new_answer_path
  end

  #ログアウト後の遷移先
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
