Devise.setup do |config|
  config.mailer = 'Users::Mailer'
  config.mailer_sender = 'mekunyauchi@gmail.com'
  require 'devise/orm/active_record'
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..20
  config.timeout_in = 1.day
  config.confirm_within = 1.days
  config.scoped_views = true
  config.sign_out_via = :delete

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  ## ここからが ソーシャルログイン
  config.omniauth :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  config.omniauth :twitter, ENV['TWITTER_API_KEY'], ENV['TWITTER_API_SECRET']
  config.omniauth :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
  ## ここまでが ソーシャルログイン

end
