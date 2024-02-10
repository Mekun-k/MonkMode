User.create(
  name: "ゲスト",
  email: "guest@example.com",
  confirmed_at: Time.now,
  password: SecureRandom.urlsafe_base64(n = 10)
)

now = Time.current
beginning_day = now.beginning_of_month
end_day = now.end_of_month

MAX_SCORE = -15
MIN_SCORE = 15

18.times do
  Answer.create(
    user_id: 1,
    score: Random.rand(MAX_SCORE..MIN_SCORE),
    created_at: Random.rand(beginning_day..end_day)
  )
end
