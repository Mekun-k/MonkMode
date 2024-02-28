RULE_TITLES = [
  "",
  "時に起床できたか?",
  "時間以上、睡眠時間を確保できたか?",
  "分以上、日光を浴びたか?",
  "分以上、運動時間を確保できたか?",
  "時間以上、目標に対して時間を費やしたか?",
  "g以上、脂質を摂取できたか?",
  "g以上,タンパク質を摂取できたか?",
  "時間以下に娯楽の視聴時間を制限できたか？",
  "ポルノを見なかったか?",
  "自慰行為をしなかったか?",
  "ショート動画を見なかったか?",
  "ジャンクフードを食べなかったか?",
  "酒、タバコを摂取していないか?",
  "ギャンブルをしなかったか?",
]

RULE_CONTENTS = [
  "ユーザーが設定可能",
  "6",
  "7",
  "15",
  "30",
  "1",
  "60",
  "120",
  "1",
  "nil",
  "nil",
  "nil",
  "nil",
  "nil",
  "nil"
]

RULE_TYPES = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  false,
  false,
  false,
  false,
  false,
  false
]

LEVELS = [
  1,2,3,4,5,6,7,8,9,10,11,12,13,14,
]

now = Time.current
beginning_day = now.beginning_of_month
end_day = now.end_of_month

user = User.create(
  name: "ゲスト",
  email: "guest@example.com",
  confirmed_at: Time.now,
  password: SecureRandom.urlsafe_base64(n = 10),
  self_introduction: "閲覧用のアカウントです"
)

Rule.rule_setting(user)

rules = Rule.all

generated_dates = []

18.times do
  random_date = nil

  loop do
    random_date = Random.rand(beginning_day..end_day).to_date
    break if !generated_dates.include?(random_date) && random_date != Date.today
  end

  generated_dates << random_date

  answer = Answer.new(
    user_id: 1,
    created_at: Time.zone.local(random_date.year, random_date.month, random_date.day, 0, 0, 0)
  )

  begin
    answer.save!
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  rules.each do |rule|
    ChildAnswer.answer_setting(user, answer, rule.id, [true, false].sample)
  end

  Answer.score_create(answer)
end

level = 1
thresold = 1

100.times do
  LevelSetting.create(level: level, thresold: thresold)

  level += 1
  thresold += 10
end

user.experience_point = user.answers.pluck(:score).sum
user.save

loop do
  levelsetting = LevelSetting.find_by(level: user.level + 1)

  # 次のレベルの閾値を超えていない場合はループを終了
  break if levelsetting.thresold > user.experience_point

  # レベルアップ
  user.level += 1
  user.save
end

