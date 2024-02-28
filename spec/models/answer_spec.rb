require 'rails_helper'

describe User do

  describe '振り返り作成' do
    # 1
    it "振り返りが作成できること" do
      user = build(:user)
      expect { answer = FactoryBot.create(:answer, user: user) }.to change { Answer.count }.by(+1)
    end
  end

  describe 'associations' do
    # 1
    it "answerに関連付いたchild_answersレコードが生成されること" do
      user = build(:user)
      answer = FactoryBot.create(:answer, user: user)
      rule = FactoryBot.create(:rule, user: user)

      child_answer1 = FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule)
      child_answer2 = FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule)

      expect(answer.child_answers).to include(child_answer1, child_answer2)
    end

    # 2
    it "answerに関連付いたcommentsレコードが生成されること" do
      user = build(:user)
      answer = FactoryBot.create(:answer, user: user)

      comment1 = FactoryBot.create(:comment, user: user, answer: answer)
      comment2 = FactoryBot.create(:comment, user: user, answer: answer)

      expect(answer.comments).to include(comment1, comment2)
    end

    # 3
    it "answerに関連付いたfavoritesレコードが生成されること" do
      user = build(:user)
      answer = FactoryBot.create(:answer, user: user)

      favorite1 = FactoryBot.create(:favorite, user: user, answer: answer)
      favorite2 = FactoryBot.create(:favorite, user: user, answer: answer)

      expect(answer.favorites).to include(favorite1, favorite2)
    end

    # 4
    it "answerに関連付いたnotificationsレコードが生成されること" do
      user = FactoryBot.create(:user)
      answer = FactoryBot.create(:answer, user: user)
      comment = FactoryBot.create(:comment, user: user, answer: answer)

      another_user1 = FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com")
      another_user2 = FactoryBot.create(:user, name: "ゲスト2", email: "test2@gmail.com")

      notification1 = FactoryBot.create(:notification, visitor_id: another_user1.id, visited_id: user.id, answer_id: answer.id, comment_id: comment.id, action: "comment", checked: false)
      notification2 = FactoryBot.create(:notification, visitor_id: another_user2.id, visited_id: user.id, answer_id: answer.id, comment_id: comment.id, action: "comment", checked: false)

      expect(answer.notifications).to include(notification1, notification2)
    end
  end

  describe 'class_method' do
    # 1
    describe '#commented?(user) が正常に動くか' do
      it "結果がtrueであること" do
        user = build(:user)
        answer = FactoryBot.create(:answer, user: user)
        comment = FactoryBot.create(:comment, user: user, answer: answer)
        expect(answer.commented?(user)).to be true
      end
    end

    # 2
    describe '#favorited?(user) が正常に動くか' do
      it "結果がtrueであること" do
        user = build(:user)
        answer = FactoryBot.create(:answer, user: user)
        favorite = FactoryBot.create(:favorite, user: user, answer: answer)
        expect(answer.favorited?(user)).to be true
      end
    end

    # 3
    describe '#score_create(answer) が正常に動くか' do
      it "期待している値と同じになるか" do
        user = build(:user)
        answer = FactoryBot.create(:answer, user: user)
        rule = FactoryBot.create(:rule, user: user)
        14.times do
          FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule, content: true)
        end
        FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule, content: false)
        Answer.score_create(answer)
        expect(answer.score).to eq(14)
      end

      it "child_answerレコード==15 以外のときに保存処理がされないこと" do
        user = build(:user)
        answer = FactoryBot.create(:answer, user: user)
        rule = FactoryBot.create(:rule, user: user)

        14.times do
          FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule, content: true)
        end

        expect(Answer.score_create(answer)).to be true
      end
    end

    # 4
    describe '#self.success_result(answer) が正常に動くか' do
      it "期待している値と同じになるか" do
        user = build(:user)
        answer = FactoryBot.create(:answer, user: user)
        rule = FactoryBot.create(:rule, user: user)

        child_answer1 = ChildAnswer.answer_setting(user, answer, rule.id, true)
        child_answer2 = ChildAnswer.answer_setting(user, answer, rule.id, false)
        child_answer3 = ChildAnswer.answer_setting(user, answer, rule.id, true)
        child_answer4 = ChildAnswer.answer_setting(user, answer, rule.id, false)

        expect(Answer.success_result(answer)).to be 2
      end
    end

  end

end
