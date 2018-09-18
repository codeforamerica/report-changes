module CredentialsHelper
  def self.secret_key_for_ssn_encryption
    if Rails.env.test?
      "This is a key that is 256 bits!!"
    else
      Rails.application.credentials[Rails.env.to_sym][:secret_key_for_ssn_encryption]
    end
  end
end
