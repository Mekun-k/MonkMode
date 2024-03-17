require 'rails_helper'

RSpec.describe "Contacts", type: :system do
  it "お問い合わせページにアクセスできる" do
    visit root_path
    expect(page).to have_content("自分の足を引っ張る余計なものを徹底的に排除し結果を出すための生活を徹底するライフスタイル")

    click_link "お問い合わせ"
    expect(page).to have_current_path(new_contact_path)
    expect(page).to have_content("お問い合わせ")
  end

  it "お問い合わせメールが送信できる" do
    visit root_path
    click_link "お問い合わせ"

    # 失敗した場合
    click_button "入力内容確認"
    expect(page).to have_content("「お名前」と「メッセージ」を入力してください")
    expect(page).to have_current_path(confirm_path)

    # 成功した場合
    fill_in 'お名前', with: 'hoge_name'
    fill_in 'メッセージ', with: 'hoge_content'
    click_button "入力内容確認"

    expect(page).to have_current_path(confirm_path)
    expect(page).to have_content("hoge_name")
    expect(page).to have_content("hoge_content")

    # 入力画面に戻るボタンの確認
    click_button "入力画面に戻る"
    expect(page).to have_current_path(back_path)
    expect(page).to have_content("お問い合わせ")
    expect(page).to have_xpath("//input[@value='hoge_name']")
    expect(page).to have_field 'お名前', with: 'hoge_name'
    expect(page).to have_field 'メッセージ', with: 'hoge_content'
    click_button "入力内容確認"

    expect { click_button "送信" }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_current_path(root_path)
    expect(page).to have_content("お問い合わせメールの送信が完了しました。")
  end
end
