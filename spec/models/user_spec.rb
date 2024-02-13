require 'rails_helper'

describe User do

  describe 'ユーザー登録' do
    # 1
    it "name、email、passwordとpassword_confirmationが存在すれば登録できること" do
      user = build(:user)
      expect(user).to be_valid
    end

    # 2
    it "nameがない場合は登録できないこと" do
      user = build(:user, name: "")
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    # 3
    it "emailがない場合は登録できないこと" do
      user = build(:user, email: "")
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    # 4
    it "passwordがない場合は登録できないこと" do
      user = build(:user, password: "")
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    # 5
    it "passwordが存在してもpassword_confirmationがない場合は登録できないこと" do
      user = build(:user, password_confirmation: "")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end

    # 6
    it "重複したemailが存在する場合登録できないこと" do
      user = create(:user)
      another_user = build(:user)
      another_user.valid?
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end

    # 7
    it "重複したnameが存在する場合登録できないこと" do
      user = create(:user)
      another_user = build(:user)
      another_user.valid?
      expect(another_user.errors[:name]).to be_empty
    end
  end

  describe 'associations' do
    # 1
    it "userに関連付いたanswerレコードが生成されること" do
      user = build(:user)
      answer1 = FactoryBot.create(:answer, user: user)
      answer2 = FactoryBot.create(:answer, user: user)
      expect(user.answers).to include(answer1, answer2)
    end

    # 2
    it "userに関連付いたrulesレコードが生成されること" do
      user = build(:user)
      rule1 = FactoryBot.create(:rule, user: user)
      rule2 = FactoryBot.create(:rule, user: user)
      expect(user.rules).to include(rule1, rule2)
    end

    # 3
    it "userに関連付いたchild_answerレコードが生成されること" do
      user = build(:user)
      answer = FactoryBot.create(:answer, user: user)
      rule = FactoryBot.create(:rule, user: user)

      child_answer1 = FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule)
      child_answer2 = FactoryBot.create(:child_answer, user: user, answer: answer, rule: rule)

      expect(user.child_answers).to include(child_answer1, child_answer2)
    end

    # 4
    it "userに関連付いたcommentsレコードが生成されること" do
      user = build(:user)
      answer = FactoryBot.create(:answer, user: user)

      comment1 = FactoryBot.create(:comment, user: user, answer: answer)
      comment2 = FactoryBot.create(:comment, user: user, answer: answer)

      expect(user.comments).to include(comment1, comment2)
    end

    # 5
    it "userに関連付いたfavoritesレコードが生成されること" do
      user = build(:user)
      answer = FactoryBot.create(:answer, user: user)

      favorite1 = FactoryBot.create(:favorite, user: user, answer: answer)
      favorite2 = FactoryBot.create(:favorite, user: user, answer: answer)

      expect(user.favorites).to include(favorite1, favorite2)
    end

    # 6
    it "userに関連付いたrelationshipsレコードが生成されること" do
      user = FactoryBot.create(:user)
      another_user1 = FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com")
      another_user2 = FactoryBot.create(:user, name: "ゲスト2", email: "test2@gmail.com")

      relationship1 = FactoryBot.create(:relationship, follower_id: user.id, followed_id: another_user1.id)
      relationship2 = FactoryBot.create(:relationship, follower_id: user.id, followed_id: another_user2.id)

      expect(user.relationships).to include(relationship1, relationship2)
    end

    # 7
    it "userに関連付いたnotificationsレコードが生成されること" do
      user = FactoryBot.create(:user)
      answer = FactoryBot.create(:answer, user: user)
      comment = FactoryBot.create(:comment, user: user, answer: answer)

      another_user1 = FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com")
      another_user2 = FactoryBot.create(:user, name: "ゲスト2", email: "test2@gmail.com")

      notification1 = FactoryBot.create(:notification, visitor_id: another_user1.id, visited_id: user.id, answer_id: answer.id, comment_id: comment.id, action: "comment", checked: false)
      notification2 = FactoryBot.create(:notification, visitor_id: another_user2.id, visited_id: user.id, answer_id: answer.id, comment_id: comment.id, action: "comment", checked: false)

      expect(user.passive_notifications).to include(notification1, notification2)
    end
  end

  describe 'class_method' do

    # 1
    describe '#map(user) が正常に動くか' do
      it "ヒートマップの値が生成されるか" do
        user = FactoryBot.create(:user)
        answer1 = FactoryBot.create(:answer, user: user, created_at: Time.now - 1.day, score: 5)
        answer2 = FactoryBot.create(:answer, user: user, created_at: Time.now - 2.days, score: 10)

        heatmap_value = user.map(user)

        expected_heatmap_value = { answer1.created_at.to_i => answer1.score, answer2.created_at.to_i => answer2.score }

        expect(heatmap_value).to eq(expected_heatmap_value)
      end
    end

    # 2
    describe '#own?(object) が正常に動くか' do
      it "ユーザーが作成したオブジェクトを引数として渡したときtrueになるか" do
        user = FactoryBot.create(:user)
        answer = FactoryBot.create(:answer, user: user)

        expect(user.own?(answer)).to be true
      end
    end

    # 3
    describe '#follow(user_id) が正常に動くか' do
      it "relationshipsオブジェクトのfollowed_id,follower_idが狙い通りか" do
        user = FactoryBot.create(:user)
        another_user = FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com")

        relationship = user.follow(another_user.id)

        expected_relationship_attributes = {
          follower_id: user.id,
          followed_id: another_user.id
        }

        expect(relationship).to have_attributes(expected_relationship_attributes)
      end
    end

    # 4
    describe '#unfollow(user_id) が正常に動くか' do
      it "relationshipsレコードが削除されるか" do
        user = FactoryBot.create(:user)
        another_user = FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com")
        relationship = FactoryBot.create(:relationship, follower_id: user.id, followed_id: another_user.id)

        expect { user.unfollow(another_user.id) }.to change { Relationship.count }.by(-1)
      end
    end

    # 5
    describe '#following?(user) が正常に動くか' do
      it "フォロー中のユーザーを引数として渡したときにtrueになるか" do
        user = FactoryBot.create(:user)
        another_user = FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com")
        relationship = FactoryBot.create(:relationship, follower_id: user.id, followed_id: another_user.id)

        expect(user.following?(another_user)).to be true
      end
    end
  end

end


