class Rule < ApplicationRecord
  default_scope { order(:id) }
  belongs_to :user
  has_many :child_answers, dependent: :destroy
  validates :rule_content, presence: true

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

  def self.rule_setting(user)
    RULE_TITLES.zip(RULE_CONTENTS, RULE_TYPES).first(Answer::HASH_MAX_NUMBER).each { |title , content , type|
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
