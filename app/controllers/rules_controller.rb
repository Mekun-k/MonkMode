class RulesController < ApplicationController
  before_action :authenticate_user!

  def index
    @rules = current_user.rules ||= ""
  end

  def update

    @rules = rule_params

    is_error = false

    @rules['content'].each do |key, value|
      @rule = Rule.find(key)
      @rule.rule_content = value
      if !(@rule.save)
        is_error = true
      end
    end

    if is_error
      flash[:error] = "ルール設定の更新に失敗しました"
      redirect_back(fallback_location: rules_path)
    else
      flash[:notice] = "ルール設定を更新しました"
      redirect_to rules_path, notice: "ルール設定を更新しました"
    end

  end

  private

  def rule_params
    params.require(:rule).permit(content: {})
  end

end
