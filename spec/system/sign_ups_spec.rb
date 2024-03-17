require 'rails_helper'

RSpec.describe "SignUps", type: :system do
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    puts body[/http[^"]+/]
  end

  it "新規登録ページに遷移する" do
    visit root_path
    expect(page).to have_content("自分の足を引っ張る余計なものを徹底的に排除し結果を出すための生活を徹底するライフスタイル")

    click_link "サインアップ"
    expect(page).to have_current_path(new_user_registration_path)
    expect(page).to have_content("ユーザー登録")
  end

  it "ユーザー新規登録" do
    visit root_path
    expect(page).to have_content("自分の足を引っ張る余計なものを徹底的に排除し結果を出すための生活を徹底するライフスタイル")
    click_link "サインアップ"

    expect(page).to have_current_path(new_user_registration_path)
    expect(page).to have_content("ユーザー登録")

    # 登録に失敗する場合
    click_button '登録'
    expect(page).to have_content "メールアドレスを入力してください"
    expect(page).to have_content "パスワードを入力してください"
    expect(page).to have_content "名前を入力してください"

    fill_in '名前', with: 'hoge'
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'passwords'
    click_button '登録'
    expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'

    # 登録に成功する場合
    fill_in '名前', with: 'hoge'
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'

    expect { click_button "登録" }.to change { ActionMailer::Base.deliveries.size }.by(1)

    expect(page).to have_content("ユーザー認証メールを送信いたしました。認証が完了しましたらログインをお願いいたします。")
    expect(page).to have_current_path(new_user_session_path)

    user = User.last
    token = user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)
    expect(page).to have_content("メールアドレスが確認できました。")

    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    click_button "ログイン"

    expect(page).to have_content("ログインしました。")
    expect(page).to have_current_path(new_answer_path)
  end

  it "ゲストログインが正常に動作する" do
    visit root_path
    click_link "ログイン"
    click_link "ゲストログイン"
    expect(page).to have_content("ゲストユーザーとしてログインしました。")
    expect(page).to have_current_path(new_answer_path)
    click_on "navbarDropdown"
    click_on "ログアウト"
    expect(page).to have_content("ログアウトしました。")
    expect(page).to have_current_path(root_path)
  end

  it "通常ログインが正常に動作する" do
    visit root_path
    click_link "サインアップ"
    fill_in '名前', with: 'hoge'
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'
    click_button "登録"
    user = User.last
    token = user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)

    # ログインに失敗する場合
    fill_in 'メールアドレス', with: 'foo@example.coms'
    fill_in 'パスワード', with: 'passwords'
    click_button "ログイン"
    expect(page).to have_content("メールアドレスまたはパスワードが違います。")
    expect(page).to have_current_path(new_user_session_path)

    # ログインに成功する場合
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    click_button "ログイン"

    expect(page).to have_content("ログインしました。")
    expect(page).to have_current_path(new_answer_path)
  end

  it "ログアウト処理" do
    visit root_path
    click_link "サインアップ"
    fill_in '名前', with: 'hoge'
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'パスワード（確認用）', with: 'password'
    click_button "登録"
    user = User.last
    token = user.confirmation_token
    visit user_confirmation_path(confirmation_token: token)
    fill_in 'メールアドレス', with: 'foo@example.com'
    fill_in 'パスワード', with: 'password'
    click_button "ログイン"

    click_on "navbarDropdown"
    click_on "ログアウト"
    expect(page).to have_content("ログアウトしました。")
    expect(page).to have_current_path(root_path)
  end
end
