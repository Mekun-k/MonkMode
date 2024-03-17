require 'rails_helper'

RSpec.describe "Answers", type: :system do
  it "振り返り機能が正常に作動すること" do
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
    # 1
    expect(page).to have_content("ユーザーが設定可能")
    choose '未達'
    click_button '次の質問へ'

    # 2
    expect(page).to have_content("6時に起床できたか?")
    choose '未達'
    click_button '次の質問へ'

    # 3
    expect(page).to have_content("7時間以上、睡眠時間を確保できたか?")
    choose '未達'
    click_button '次の質問へ'

    # 4
    expect(page).to have_content("15分以上、日光を浴びたか?")
    choose '未達'
    click_button '次の質問へ'

    # 5
    expect(page).to have_content("30分以上、運動時間を確保できたか?")
    choose '未達'
    click_button '次の質問へ'

    # 6
    expect(page).to have_content("1時間以上、目標に対して時間を費やしたか?")
    choose '未達'
    click_button '次の質問へ'

    # 7
    expect(page).to have_content("60g以上、脂質を摂取できたか?")
    choose '未達'
    click_button '次の質問へ'

    # 8
    expect(page).to have_content("120g以上,タンパク質を摂取できたか?")
    choose '未達'
    click_button '次の質問へ'

    # 9
    expect(page).to have_content("1時間以下に娯楽の視聴時間を制限できたか？")
    choose '未達'
    click_button '次の質問へ'

    # 10
    expect(page).to have_content("ポルノを見なかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 11
    expect(page).to have_content("自慰行為をしなかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 12
    expect(page).to have_content("ショート動画を見なかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 13
    expect(page).to have_content("ジャンクフードを食べなかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 14
    expect(page).to have_content("酒、タバコを摂取していないか?")
    choose '達成'
    click_button '次の質問へ'

    # 15
    expect(page).to have_content("ギャンブルをしなかったか?")
    choose '達成'
    click_button '回答を保存する'

    expect(page).to have_content("振り返りを実施しました")
    expect(page).to have_content("経験値6Exp")
    expect(page).to have_content("達成率6/15")

    click_link "結果一覧"
    expect(page).to have_current_path(answers_path)
    expect(page).to have_content("ゲスト")
    expect(page).to have_content("MONK Lv. 1")
    expect(page).to have_content("経験値6Exp")
    expect(page).to have_content("達成率6/15")
  end

  it "振り返り時、モンクレベルが上がること" do
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
    # 1
    expect(page).to have_content("ユーザーが設定可能")
    choose '達成'
    click_button '次の質問へ'

    # 2
    expect(page).to have_content("6時に起床できたか?")
    choose '達成'
    click_button '次の質問へ'

    # 3
    expect(page).to have_content("7時間以上、睡眠時間を確保できたか?")
    choose '達成'
    click_button '次の質問へ'

    # 4
    expect(page).to have_content("15分以上、日光を浴びたか?")
    choose '達成'
    click_button '次の質問へ'

    # 5
    expect(page).to have_content("30分以上、運動時間を確保できたか?")
    choose '達成'
    click_button '次の質問へ'

    # 6
    expect(page).to have_content("1時間以上、目標に対して時間を費やしたか?")
    choose '達成'
    click_button '次の質問へ'

    # 7
    expect(page).to have_content("60g以上、脂質を摂取できたか?")
    choose '達成'
    click_button '次の質問へ'

    # 8
    expect(page).to have_content("120g以上,タンパク質を摂取できたか?")
    choose '達成'
    click_button '次の質問へ'

    # 9
    expect(page).to have_content("1時間以下に娯楽の視聴時間を制限できたか？")
    choose '達成'
    click_button '次の質問へ'

    # 10
    expect(page).to have_content("ポルノを見なかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 11
    expect(page).to have_content("自慰行為をしなかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 12
    expect(page).to have_content("ショート動画を見なかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 13
    expect(page).to have_content("ジャンクフードを食べなかったか?")
    choose '達成'
    click_button '次の質問へ'

    # 14
    expect(page).to have_content("酒、タバコを摂取していないか?")
    choose '達成'
    click_button '次の質問へ'

    # 15
    expect(page).to have_content("ギャンブルをしなかったか?")
    choose '達成'
    click_button '回答を保存する'

    expect(page).to have_content("振り返りを実施しました。MONK Lv.2に上がった！")
    expect(page).to have_content("経験値15Exp")
    expect(page).to have_content("達成率15/15")

    click_link "結果一覧"
    expect(page).to have_current_path(answers_path)
    expect(page).to have_content("ゲスト")
    expect(page).to have_content("MONK Lv. 2")
    expect(page).to have_content("経験値15Exp")
    expect(page).to have_content("達成率15/15")
  end
end
