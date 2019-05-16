module CredentialsHelper
  class << self
    def secret_key_for_ssn_encryption
      environment_credential_for_key(:secret_key_for_ssn_encryption,
                                     alternate_value: "This is a key that is 256 bits!!")
    end

    def ganalytics
      environment_credential_for_key(:ganalytics)
    end

    def county_email_address(report)
      if report.navigator.county == "Arapahoe"
        environment_credential_for_key(:arapahoe_county_email_address, alternate_value: "arapahoe@example.com")
      elsif report.navigator.county == "Pitkin"
        environment_credential_for_key(:pitkin_county_email_address, alternate_value: "pitkin@example.com")
      end
    end

    def environment_credential_for_key(key, alternate_value: nil)
      if Rails.env.test? || Rails.env.development?
        alternate_value
      else
        Rails.application.credentials[Rails.env.to_sym][key.to_sym]
      end
    end
  end
end
