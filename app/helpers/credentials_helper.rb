module CredentialsHelper
  def self.secret_key_for_ssn_encryption
    if Rails.env.test?
      "This is a key that is 256 bits!!"
    else
      Rails.application.credentials[Rails.env.to_sym][:secret_key_for_ssn_encryption]
    end
  end

  def self.ganalytics
    Rails.application.credentials[Rails.env.to_sym][:ganalytics]
  end

  def self.county_email_address
    if Rails.env.test?
      "county@example.com"
    else
      Rails.application.credentials[Rails.env.to_sym][:county_email_address]
    end
  end
end
