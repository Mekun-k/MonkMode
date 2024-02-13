require 'rails_helper'

describe Relationship do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user, name: "ゲスト1", email: "test1@gmail.com") }

  before do
    @relationship_params = { follower_id: user.id, followed_id: another_user.id }
  end

  describe 'フォロー・フォロワー作成' do

    # 1
    it "relationshipsレコードが新しく作成されること" do
      expect { FactoryBot.create(:relationship, @relationship_params) }.to change { Relationship.count }.by(+1)
    end

  end

end
