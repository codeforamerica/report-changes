if Rails.env.development? || Rails.env.test? || Rails.env.demo?
  require File.expand_path("#{Rails.root}/spec/support/fake_sms_client")
  SmsClient = FakeSmsClient
else
  Twilio.configure do |config|
    config.account_sid = ENV["TWILIO_ACCOUNT_SID"]
    config.auth_token = ENV["TWILIO_AUTH_TOKEN"]
  end
end
