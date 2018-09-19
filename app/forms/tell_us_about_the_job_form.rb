class TellUsAboutTheJobForm < Form
  set_attributes_for :change_report, :company_name, :company_address, :company_phone_number, :last_day_year,
                     :last_day_month, :last_day_day, :last_paycheck_year, :last_paycheck_month, :last_paycheck_day

  validates_presence_of :company_name, message: "Please add a name."
  validates_presence_of :company_address, message: "Please add an address or cross streets."
  validates :company_phone_number, ten_digit_phone_number: true
  attr_internal_reader :last_day, :last_paycheck
  validates :last_day, date: true
  validates :last_paycheck, date: true
  before_validation :strip_dashes_from_phone_number

  def save
    change_report.update(
      company_name: company_name,
      company_address: company_address,
      company_phone_number: company_phone_number,
      last_day: to_datetime(last_day_year, last_day_month, last_day_day),
      last_paycheck: to_datetime(last_paycheck_year, last_paycheck_month, last_paycheck_day),
    )
  end

  private

  def strip_dashes_from_phone_number
    strip_dashes(:company_phone_number)
  end
end
