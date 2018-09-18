class TellUsAboutYourselfForm < Form
  include BirthdayValidations

  set_attributes_for :member, :name, :ssn, :birthday_year, :birthday_month, :birthday_day
  set_attributes_for :change_report, :phone_number, :case_number
  attr_accessor :change_report

  before_validation :strip_dashes_from_phone_number, :strip_dashes_from_ssn

  validates_presence_of :name, message: "Please add your name."
  validates :phone_number, length: { is: 10, message: "Please add a ten digit phone number, including area code." }
  validates :ssn, length: { is: 9, message: "Please add a 9 digit social security number", allow_blank: true }
  validate :birthday_must_be_present, :birthday_must_be_valid_date

  def save
    change_report.update!(change_report_data)

    if change_report.member.present?
      change_report.member.update(member_data)
    else
      change_report.create_member(member_data)
    end
  end

  private

  def strip_dashes_from_phone_number
    strip_dashes(:phone_number)
  end

  def strip_dashes_from_ssn
    strip_dashes(:ssn)
  end

  def strip_dashes(field_name)
    send("#{field_name}=", send(field_name).delete("-")) unless send(field_name).nil?
  end

  def change_report_data
    {
      phone_number: phone_number,
      case_number: case_number,
    }
  end

  def member_data
    {
      name: name,
      ssn: ssn,
      birthday: birthday,
    }
  end

  def birthday
    DateTime.new(birthday_year.to_i, birthday_month.to_i, birthday_day.to_i)
  end
end
