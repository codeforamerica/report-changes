require "administrate/field/base"

class PhoneNumberField < Administrate::Field::Base
  def to_s
    resource&.submitter&.phone_number || resource&.members&.first&.phone_number
  end
end
