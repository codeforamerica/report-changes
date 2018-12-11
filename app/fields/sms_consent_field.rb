require "administrate/field/base"

class SmsConsentField < Administrate::Field::Base
  def to_s
    resource&.metadata&.consent_to_sms
  end
end
