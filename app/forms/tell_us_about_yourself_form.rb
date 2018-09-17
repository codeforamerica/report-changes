class TellUsAboutYourselfForm < Form
  include BirthdayValidations

  set_attributes_for :member, :name, :ssn, :birthday_year, :birthday_month, :birthday_day
  set_attributes_for :change_report, :phone_number, :case_number

  before_validation :strip_dashes_from_phone_number, :strip_dashes_from_ssn

  validates_presence_of :name, message: "Please add your name."
  validates :phone_number, length: { is: 10, message: "Please add a ten digit phone number, including area code." }
  validates :ssn, length: { is: 9, message: "Please add a 9 digit social security number", allow_blank: true }
  validate :birthday_must_be_present, :birthday_must_be_valid_date

  def strip_dashes_from_phone_number
    strip_dashes(:phone_number)
  end

  def strip_dashes_from_ssn
    strip_dashes(:ssn)
  end

  private

  def strip_dashes(field_name)
    send("#{field_name}=", send(field_name).delete("-")) unless send(field_name).nil?
  end
end
