require 'rails_helper'

RSpec.describe "Rules", type: :system do
  it "ルール設定ページにデフォルトルールが設定されている" do
    expect { visit root_path }.to change { Rule.count }.by(+0)
    click_link "ログイン"
    expect { click_link "ゲストログイン" }.to change { Rule.count }.by(+15)
    visit rules_path
    expect(page).to have_current_path(rules_path)
    expect(page).to have_xpath("//input[@value='ユーザーが設定可能']")
    expect(page).to have_xpath("//input[@value='6']")
    expect(page).to have_xpath("//input[@value='7']")
    expect(page).to have_xpath("//input[@value='15']")
    expect(page).to have_xpath("//input[@value='30']")
    expect(page).to have_xpath("//input[@value='1']")
    expect(page).to have_xpath("//input[@value='60']")
    expect(page).to have_xpath("//input[@value='120']")
    expect(page).to have_xpath("//input[@value='1']")
    expect(page).to have_content("時に起床できたか?")
    expect(page).to have_content("時間以上、睡眠時間を確保できたか?")
    expect(page).to have_content("分以上、日光を浴びたか?")
    expect(page).to have_content("分以上、運動時間を確保できたか?")
    expect(page).to have_content("時間以上、目標に対して時間を費やしたか?")
    expect(page).to have_content("g以上、脂質を摂取できたか?")
    expect(page).to have_content("g以上,タンパク質を摂取できたか?")
    expect(page).to have_content("時間以下に娯楽の視聴時間を制限できたか？")
    expect(page).to have_content("ポルノを見なかったか?")
    expect(page).to have_content("自慰行為をしなかったか?")
    expect(page).to have_content("ショート動画を見なかったか?")
    expect(page).to have_content("ジャンクフードを食べなかったか?")
    expect(page).to have_content("酒、タバコを摂取していないか?")
    expect(page).to have_content("ギャンブルをしなかったか?")
  end

  it "ルール設定が正常に作動する" do
    expect { visit root_path }.to change { Rule.count }.by(+0)
    click_link "ログイン"
    expect { click_link "ゲストログイン" }.to change { Rule.count }.by(+15)
    visit rules_path
    expect(page).to have_current_path(rules_path)
    expect(page).to have_xpath("//input[@value='ユーザーが設定可能']")
    expect(page).not_to have_xpath("//input[@value='瞑想実施']")
    fill_in '自由に設定可能', with: '瞑想実施'
    click_button '更新'
    expect(page).to have_current_path(rules_path)
    expect(page).to have_xpath("//input[@value='瞑想実施']")
    expect(page).to have_content("ルール設定を更新しました")

    # 要素を空にすると失敗する
    fill_in '自由に設定可能', with: ''
    click_button '更新'
    expect(page).to have_current_path(rules_path)
    expect(page).to have_xpath("//input[@value='瞑想実施']")
    expect(page).to have_content("ルール設定の更新に失敗しました")
  end
end
