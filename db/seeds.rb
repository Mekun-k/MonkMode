User.create(
  name: "ゲスト",
  email: "guest@example.com",
  confirmed_at: Time.now,
  password: SecureRandom.urlsafe_base64(n = 10)
)

Answer.create(
  user_id: 1,
  score: -10,
  created_at: Time.zone.parse('2024-01-09 12:00:00')
)

Answer.create(
  user_id: 1,
  score: -5,
  created_at: Time.zone.parse('2024-01-10 12:00:00')
)

Answer.create(
  user_id: 1,
  score: 0,
  created_at: Time.zone.parse('2024-01-11 12:00:00')
)

Answer.create(
  user_id: 1,
  score: 5,
  created_at: Time.zone.parse('2024-01-12 12:00:00')
)

Answer.create(
  user_id: 1,
  score: 10,
  created_at: Time.zone.parse('2024-01-13 12:00:00')
)

Answer.create(
  user_id: 1,
  score: 15,
  created_at: Time.zone.parse('2024-01-14 12:00:00')
)