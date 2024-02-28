class AnswersController < ApplicationController
  before_action :authenticate_user!

  def index
    @answers = current_user.answers.order(created_at: :desc).page(params[:page]).per(5)
  end

  def board
    @answers = Answer.all.includes(:user).order(created_at: :desc).page(params[:page]).per(5)
  end

  def new
    @answer = Answer.new()
    @answer.user_id = current_user.id

    @rules = current_user.rules
  end

  def show
    @answer = Answer.find_by(id: params[:id])
    @comment = Comment.new
    @comments = @answer.comments.includes(:user).order(created_at: :desc)

    @child_answers = @answer.child_answers
    @success_result = Answer.success_result(@answer)
    @answer.user.map(current_user)

    @twitter_share_url = answer_url(@answer)
    twitter_share_text = "【今日の振り返り】\n\n・経験値: #{@answer.score}Exp\n・達成率: #{Answer.success_result(@answer)}/15\n\n詳細はこちら▼"
    @encodedText = URI.encode_www_form_component(twitter_share_text)
    twitter_share_tags = ["MonkMode", "モンクモード"]
    @hashtags = URI.encode_www_form_component(twitter_share_tags.join(","))
  end

  def create

    today = Time.zone.today.strftime("%Y年 %m月 %d日")

    days = current_user.answers.pluck(:created_at)

    days.each do |d|
      if d.strftime("%Y年 %m月 %d日") == today
        flash[:alert] = "振り返りは一日一回までです！"
        @rules = current_user.rules ||= ""
        redirect_back(fallback_location: new_answer_path) and return
      end
    end

    @rules = current_user.rules
    @child_answers = answer_params
    @answer = Answer.new(user_id: current_user.id)
    @user = @answer.user

    is_error = false

    if @child_answers['value'].to_hash.size == Answer::HASH_MAX_NUMBER

      if @answer.save
        @child_answers['value'].each do |key, value|
          if !(ChildAnswer.answer_setting(current_user, @answer, key, value))
            is_error = true
            break
          end
        end

         if is_error
          flash[:error] = "振り返り実行に失敗しました"
          @rules = current_user.rules ||= ""
          redirect_back(fallback_location: new_answer_path) and return
         else
          Answer.score_create(@answer)
         end

        User.levelup(@answer)

        levelsetting = LevelSetting.find_by(level: @user.level + 1)

        if levelsetting.thresold <= @user.experience_point
          @user.level = @user.level + 1
          @user.update(level: @user.level)
          flash[:notice] = "振り返りを実施しました。MONK Lv.#{@user.level}に上がった！"
          redirect_to answer_path(@answer) and return
        end

        flash[:notice] = "振り返りを実施しました"
        redirect_to answer_path(@answer) and return
      end

    else
      is_error = true
    end

    if is_error
      flash[:error] = "振り返り実行に失敗しました"
      @rules = current_user.rules ||= ""
      redirect_back(fallback_location: new_answer_path) and return
    end

  end

  private

  def answer_params
    params.require(:answer).permit(value: {})
  end
end
