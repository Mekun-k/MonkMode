require 'rails_helper'

describe ChildAnswer do
  let(:user) { build(:user) }
  let(:answer) { FactoryBot.create(:answer, user: user) }
  let(:rule) { FactoryBot.create(:rule, user: user) }

  before do
    @child_answer_params = { user: user, answer: answer, rule: rule }
  end

  describe '振り返り作成' do

    # 1
    it "childanswerが作成できること" do
      expect { FactoryBot.create(:child_answer, @child_answer_params) }.to change { ChildAnswer.count }.by(+1)
    end

    # 2
    it "content属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:child_answer, @child_answer_params.merge(content: nil)) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    # 3
    it "user_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:child_answer, @child_answer_params.merge(user_id: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    # 4
    it "rule_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:child_answer, @child_answer_params.merge(rule_id: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    # 5
    it "answer_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:child_answer, @child_answer_params.merge(answer_id: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end


  describe 'class_method' do

    # 1
    describe '#self.answer_setting(user, answer, rule_id, value) が正常に動くか' do
      it "ChildAnswer オブジェクトを作成してChildAnswersテーブルにレコードが1つ作成される" do
        expect { ChildAnswer.answer_setting(user, answer, rule.id, true) }.to change { ChildAnswer.count }.by(+1)
      end
    end

  end

end
