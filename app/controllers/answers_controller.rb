class AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @answer = Answer.new()
    @answer.user_id = current_user.id

    @rules = current_user.rules
    @rule = Rule.find(current_user.id)
  end

  def create

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

        Answer.score_create(@answer)

        if is_error
          flash[:notice] = "振り返り実行に失敗しました"
          @rules = current_user.rules ||= ""
          render action: :new and return
        end

        flash[:notice] = "振り返りを実施しました"
        redirect_to answers_index_path
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

  def show
  end

  private

  def answer_params
    params.require(:answer).permit(value: {})
  end
end
