class AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
    @answers = current_user.answers
  end

  def board
    @answers = Answer.all.includes(:user)
  end

  def new
    @answer = Answer.new()
    @answer.user_id = current_user.id

    @rules = current_user.rules
  end

  def show
    @answer = Answer.find_by(id: params[:id])
    @child_answers = @answer.child_answers
    @success_result = Answer.success_result(@answer)
  end

  def create

  today = Time.zone.today.strftime("%Y年 %m月 %d日")

  days = current_user.answers.pluck(:created_at)

  days.each do |d|
    if d.strftime("%Y年 %m月 %d日") == today
      flash[:notice] = "振り返りは一日一回までです！"
      @rules = current_user.rules ||= ""
      render action: :new and return
    end
  end

    @rules = current_user.rules
    @child_answers = answer_params
    @answer = Answer.new(user_id: current_user.id)

    is_error = false

    if @child_answers['value'].to_hash.size == 15

      if @answer.save
        @child_answers['value'].each do |key, value|
          if !(ChildAnswer.answer_setting(current_user, @answer, key, value))
            is_error = true
            break
          end
        end

         if is_error
          flash[:notice] = "振り返り実行に失敗しました"
          @rules = current_user.rules ||= ""
          render action: :new and return
         else
          Answer.score_create(@answer)
         end

        flash[:notice] = "振り返りを実施しました"
        redirect_to answer_path(@answer)
      end

    else
      is_error = true
    end

    if is_error
      flash[:notice] = "振り返り実行に失敗しました"
      @rules = current_user.rules ||= ""
      render action: :new and return
    end

  end

  private

  def answer_params
    params.require(:answer).permit(value: {})
  end
end
