require 'rails_helper'

describe Contact do
  describe 'お問い合わせ作成' do

    # 1
    it "お問い合わせが作成できること" do
      expect { FactoryBot.create(:contact, name: "名無し", message: "こんにちは") }.to change { Contact.count }.by(+1)
    end

    # 2
    it "name属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:contact, name: nil, message: "こんにちは") }.to raise_error(ActiveRecord::RecordInvalid)
    end

    # 3
    it "message属性がない場合は作成できないこと" do
      expect { FactoryBot.create(:contact, name: "名無し", message: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end
end
