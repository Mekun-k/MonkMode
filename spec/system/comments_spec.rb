require 'rails_helper'

RSpec.describe "Comments", type: :system do
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    puts body[/http[^"]+/]
  end

  it "コメントが作成される" do
    level = 1
    thresold = 1

    100.times do
      LevelSetting.create(level: level, thresold: thresold)
      level += 1
      thresold += 10
    end

    visit root_path
    click_link "ログイン"
    click_link "ゲストログイン"
    click_button '振り返り実施'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '未達'
    click_button '次の質問へ'
    choose '達成'
    click_button '次の質問へ'
    choose '達成'
    click_button '次の質問へ'
    choose '達成'
    click_button '次の質問へ'
    choose '達成'
    click_button '次の質問へ'
    choose '達成'
    click_button '次の質問へ'
    choose '達成'
    click_button '回答を保存する'
    click_on "navbarDropdown"
    click_on "ログアウト"

    click_link "サインアップ"
    fill_in '名前', with: 'hoge'
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'
    click_button '登録'
    user = User.last
    token = user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)
    expect(page).to have_content("メールアドレスが確認できました。")
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    click_button "ログイン"
    click_link "掲示板"
    click_link "経験値6Exp"
    expect(page).not_to have_content("good!")

    fill_in 'js-new-comment-body', with: 'good!'
    click_button "送信"
    visit current_path
    expect(page).to have_content("good!")
  end
end
