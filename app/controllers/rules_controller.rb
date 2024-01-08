class RulesController < ApplicationController
  def index
    @rules = current_user.rules ||= ""
  end

  def update

    @rules = params[:content]

    @rules.each do |key, value|
      @rule = Rule.find(key)
      @rule.rule_content = value
      unless @rule.save
        flash[:notice] = "ルール設定の更新に失敗しました"
        render rules_path
      end
    end

    flash[:notice] = "ルール設定の更新に成功しました"
    redirect_to rules_path
  end

end
