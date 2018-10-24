Slack.configure do |config|
  config.token = CredentialsHelper.environment_credential_for_key("slack_api_token")
end
