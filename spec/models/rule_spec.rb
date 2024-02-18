require 'rails_helper'

describe Rule do

  describe '振り返り作成' do
    # 1
    it "ruleが作成できること" do
      user = build(:user)
      expect { rule = FactoryBot.create(:rule, user: user) }.to change { Rule.count }.by(+1)
    end

    # 2
    it "rule_title属性がない場合は作成できないこと" do
      user = build(:user)
      expect { FactoryBot.create(:rule, user: user, rule_title: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    # 3
    it "rule_content属性がない場合は作成できないこと" do
      user = build(:user)
      expect { FactoryBot.create(:rule, user: user, rule_content: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    # 4
    it "rule_type_id属性がない場合は作成できないこと" do
      user = build(:user)
      expect { FactoryBot.create(:rule, user: user, rule_type_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    # 5
    it "user_id属性がない場合は作成できないこと" do
      user = build(:user)
      expect { FactoryBot.create(:rule, user: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end


  describe 'associations' do
    # 1
    it "ruleに関連付いたchild_answersレコードが生成されること" do
      user = build(:user)
      answer = FactoryBot.create(:answer, user: user)
      rule = FactoryBot.create(:rule, user: user)

      child_answer1 = FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule)
      child_answer2 = FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule)

      expect(rule.child_answers).to include(child_answer1, child_answer2)
    end

  end


  describe 'class_method' do

    # 1
    describe '#self.rule?(user) が正常に動くか' do
      it "与えられたユーザーに関連付けられたルールが存在する場合はnilを返す" do
        user = build(:user)
        rule = FactoryBot.create(:rule, user: user)

        expect(Rule.rule?(user)).to be nil
      end

      it "与えられたユーザーに関連付けられたルールが存在しない場合はruleレコードを15個作成する" do
        user = FactoryBot.create(:user)

        expect { Rule.rule?(user) }.to change { Rule.count }.by(15)
      end
    end

    # 2
    describe '#self.rule_setting(user) が正常に動くか' do
      it "ruleレコードを15個作成する" do
        user = FactoryBot.create(:user)

        expect { Rule.rule?(user) }.to change { Rule.count }.by(15)
      end
    end

  end

end
