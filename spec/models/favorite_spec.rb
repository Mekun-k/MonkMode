require 'rails_helper'

describe Favorite do
  let(:user) { build(:user) }
  let(:answer) { FactoryBot.create(:answer, user: user) }

  before do
    @favorite_params = { user: user, answer: answer }
  end

  describe 'お気に入り作成' do

    # 1
    it "お気に入りが作成できること" do
      expect { FactoryBot.create(:favorite, @favorite_params) }.to change { Favorite.count }.by(+1)
    end

    # 2
    it "user_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:favorite, @favorite_params.merge(user_id: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    # 3
    it "answer_id属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:favorite, @favorite_params.merge(answer_id: nil)) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end
end
