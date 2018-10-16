module CredentialsHelper
  class << self
    def secret_key_for_ssn_encryption
      environment_credential_for_key(:secret_key_for_ssn_encryption,
                                     alternate_value: "This is a key that is 256 bits!!")
    end

    def ganalytics
      environment_credential_for_key(:ganalytics)
    end

    def county_email_address
      environment_credential_for_key(:county_email_address, alternate_value: "county@example.com")
    end

    private

    def environment_credential_for_key(key, alternate_value: nil)
      if Rails.env.test? || Rails.env.development?
        alternate_value
      else
        Rails.application.credentials[Rails.env.to_sym][key.to_sym]
      end
    end
  end
end
