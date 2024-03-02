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
    check_duplicate_answer
  rescue StandardError
    flash[:error] = "振り返り実行に失敗しました"
    @rules = current_user.rules ||= ""
    redirect_to new_answer_path
  else
    @rules = current_user.rules
    @child_answers = answer_params
    @answer = Answer.new(user_id: current_user.id)
    @user = @answer.user

    if @child_answers['value'].to_hash.size == Answer::HASH_MAX_NUMBER
      ActiveRecord::Base.transaction do
        if @answer.save
          @child_answers['value'].each do |key, value|
            ChildAnswer.answer_setting(current_user, @answer, key, value)
          end

          Answer.score_create(@answer)
          User.levelup(@answer)

          levelsetting = LevelSetting.find_by(level: @user.level + 1)

          if levelsetting.thresold <= @user.experience_point
            @user.level += 1
            @user.update(level: @user.level)
            flash[:notice] = "振り返りを実施しました。MONK Lv.#{@user.level}に上がった！"
          else
            flash[:notice] = "振り返りを実施しました"
          end

          redirect_to answer_path(@answer)
        else
          flash[:error] = "振り返り実行に失敗しました"
          render new_answer_path
        end
      end
    else
      flash[:error] = "振り返り実行に失敗しました"
      render new_answer_path
    end
  end

  private

  def answer_params
    params.require(:answer).permit(value: {})
  end

  def check_duplicate_answer
    today = Time.zone.today.strftime("%Y年 %m月 %d日")
    days = current_user.answers.pluck(:created_at)

    days.each do |d|
      if d.strftime("%Y年 %m月 %d日") == today
        flash[:alert] = "振り返りは一日一回までです！"
        raise "Duplicate answer found" # 例外を発生させる
      end
    end
  end
end
