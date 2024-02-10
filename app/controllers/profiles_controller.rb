class ProfilesController < ApplicationController

  def show
    @user = User.find(params[:id])
    @answers = @user.answers.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
  end
end