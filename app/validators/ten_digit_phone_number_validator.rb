class TenDigitPhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank? || !value.match?(/\A\d{10}\z/)
      record.errors[attribute] <<
        "Please add a ten digit phone number, including area code."
    end
  end
end
