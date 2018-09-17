module BirthdayValidations
  def birthday_present?
    %i[birthday_year birthday_month birthday_day].all? { |att| send(att).present? }
  end

  def birthday_must_be_present
    unless birthday_present?
      errors.add(:birthday, missing_birthday_error)
    end
  end

  def birthday_must_be_valid_date
    if birthday_present? && !errors.added?(:birthday, missing_birthday_error)
      begin
        DateTime.new(birthday_year.to_i, birthday_month.to_i, birthday_day.to_i)
      rescue ArgumentError
        errors.add(:birthday, "Please provide a real birthday.")
      end
    end
  end

  private

  def missing_birthday_error
    field_to_message = {
      birthday_month: "a month",
      birthday_day: "a day",
      birthday_year: "a year",
    }
    missing_fields = field_to_message.reject { |field, _| send(field).present? }
    "Please add #{missing_fields.values.to_sentence}."
  end
end
