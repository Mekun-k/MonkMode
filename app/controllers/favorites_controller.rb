class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Answer.find(params[:answer_id])
    @answer_favorite = Favorite.new(user_id: current_user.id, answer_id: params[:answer_id])
    @answer_favorite.save
    @answer.create_notification_favorite!(current_user)
  end

  def destroy
    @answer = Answer.find(params[:answer_id])
    @answer_favorite = Favorite.find_by(user_id: current_user.id, answer_id: params[:answer_id])
    @answer_favorite.destroy
  end
end
