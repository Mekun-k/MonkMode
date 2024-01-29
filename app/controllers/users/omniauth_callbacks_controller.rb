class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    callback_for(:google)
  end

  def twitter
    callback_for(:twitter)
  end

  def facebook
    callback_for(:facebook)
  end

  def callback_for(provider)

    @user = User.from_omniauth(request.env['omniauth.auth'])
    @user.save!
    Rule.rule?(@user)

    if @user.persisted?
      sign_in @user
      redirect_to profile_path(@user)
    else
      redirect_to new_user_registration_path
    end

  end

  def failure
    redirect_to pages_path and return
  end

end
