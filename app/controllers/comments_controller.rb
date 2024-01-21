class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy]
  before_action :authenticate_user!

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
	end

  def update
    @comment.reload unless @comment.update(comment_update_params)
  end

  def destroy
    @comment.destroy!
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
		params.require(:comment).permit(:body).merge(answer_id: params[:answer_id])
	end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end