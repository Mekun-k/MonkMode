class Rule < ApplicationRecord
  belongs_to :user
  validates :rule_content, presence: true

  RULE_TITLES = [
    "",
    "時に起床できたか?",
    "時間以上、睡眠時間を確保できたか?",
    "分以上、日光を浴びたか?",
    "分以上、運動時間を確保できたか?",
    "時間以上、目標に対して時間を費やしたか?",
    "g以上、1日の食事の中で脂質を摂取できたか?",
    "g以上,1日の食事の中でタンパク質を摂取できたか?",
    "時間以下に1日の娯楽のスクリーンタイムを抑えることができたか？",
    "ポルノを見なかったか?",
    "自慰行為をしなかったか?",
    "ショート動画を見なかったか?",
    "ジャンクフード・コンビニ弁当・加工食品・ジュース・お菓子を食べなかった?",
    "酒、タバコを摂取していないか?",
    "ギャンブルをしなかったか?",
  ]

  RULE_CONTENTS = [
    "ユーザーが設定可能",
    "7",
    "7",
    "15",
    "30",
    "7",
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

  def self.rule_setting(user)
    RULE_TITLES.zip(RULE_CONTENTS, RULE_TYPES).first(15).each { |title , content , type|
      Rule.create(
        rule_title: title,
        rule_content: content,
        rule_type_id: type,
        user_id: user.id
      )
    }
  end

  def self.rule?(user)
    if Rule.exists?(user_id: user.id)
    else
      Rule.rule_setting(user)
    end
  end
end
