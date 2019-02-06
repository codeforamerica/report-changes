class ClientInfoForm < Form
  set_attributes_for :member, :first_name, :last_name, :ssn,
    :birthday_year, :birthday_month, :birthday_day, :phone_number, :case_number

  before_validation -> { strip_dashes(:phone_number) }
  before_validation -> { strip_dashes(:ssn) }

  validates_presence_of :first_name, message: "Please add your first name."
  validates_presence_of :last_name, message: "Please add your last name."
  validates :phone_number, ten_digit_phone_number: true, allow_blank: true
  validates :ssn, length: { is: 9, message: "Please add a 9 digit social security number", allow_blank: true }
  attr_internal_reader :birthday
  validates :birthday, date: true

  def save
    report.current_member.update(member_data)
  end

  def self.existing_attributes(report)
    if report.current_member.present?
      attributes = report.current_member.attributes
      %i[year month day].each do |sym|
        attributes["birthday_#{sym}"] = report.current_member.birthday.try(sym)
      end
      attributes[:ssn] = report.current_member.ssn
      HashWithIndifferentAccess.new(attributes)
    else
      {}
    end
  end

  private

  def member_data
    attributes = attributes_for(:member)
    attributes[:birthday] = to_datetime(birthday_year, birthday_month, birthday_day)
    attributes.except(
      :birthday_year,
      :birthday_month,
      :birthday_day,
    )
  end
end
