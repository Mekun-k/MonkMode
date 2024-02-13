require 'rails_helper'

describe Notification do

  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com") }
  let(:answer) { FactoryBot.create(:answer, user: user) }
  let(:comment) { FactoryBot.create(:comment, answer: answer, user: user) }

  before do
    @notification_params = { visitor_id: another_user.id, visited_id: user.id, answer_id: answer.id, comment_id: comment.id, action: "comment", checked: false }
  end

  describe '通知作成' do

    # 1
    it "notificationsレコードが新しく作成されること" do
      expect { FactoryBot.create(:notification, @notification_params) }.to change { Notification.count }.by(+1)
    end

    # 2
    it "visitor_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:notification, visitor_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    # 3
    it "visited_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:notification, visited_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    # 4
    it "action属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:notification, action: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    # 5
    it "checked属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:notification, checked: nil) }.to raise_error(ActiveRecord::NotNullViolation)
    end

  end

end
