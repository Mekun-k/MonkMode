require 'rails_helper'

describe Comment do
  let(:user) { build(:user) }
  let(:answer) { FactoryBot.create(:answer, user: user) }
  let(:comment) { FactoryBot.create(:comment, answer: answer, user: user) }

  before do
    @comment_params = { user: user, answer: answer }
  end

  describe '振り返り作成' do

    # 1
    it "commentが作成できること" do
      expect { FactoryBot.create(:comment, @comment_params) }.to change { Comment.count }.by(+1)
    end

    # 2
    it "body属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:comment, @comment_params.merge(body: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    describe 'body属性の長さのバリデーション' do
      context 'body属性がバリデーション設定値未満の場合' do
        # 3
        it 'バリデーションに合格' do
          comment = build(:comment, answer: answer, user: user, body: 'a' * 1000)
          expect(comment).to be_valid
        end
      end

      context 'body属性がバリデーション設定値以上の場合' do
        # 4
        it 'バリデーションに引っかかる' do
          comment = build(:comment, answer: answer, user: user, body: 'a' * 1001)
          expect(comment).not_to be_valid
        end
      end
    end

    # 5
    it "user_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:comment, @comment_params.merge(user_id: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    # 6
    it "answer_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:comment, @comment_params.merge(answer_id: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end


  describe 'associations' do
    # 1
    it "commentに関連付いたnotificationsレコードが生成されること" do
      another_user1 = FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com")
      another_user2 = FactoryBot.create(:user, name: "ゲスト2", email: "test2@gmail.com")

      notification1 = FactoryBot.create(:notification, visitor_id: another_user1.id, visited_id: user.id, answer_id: answer.id, comment_id: comment.id, action: "comment", checked: false)
      notification2 = FactoryBot.create(:notification, visitor_id: another_user2.id, visited_id: user.id, answer_id: answer.id, comment_id: comment.id, action: "comment", checked: false)

      expect(comment.notifications).to include(notification1, notification2)
    end

  end

end
