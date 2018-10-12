class TellUsAboutTheJobForm < Form
  set_attributes_for :change_report, :company_name, :last_day_year,
                     :last_day_month, :last_day_day, :last_paycheck_year,
                     :last_paycheck_month, :last_paycheck_day, :manager_name,
                     :manager_phone_number, :manager_additional_information,
                     :last_paycheck_amount

  before_validation -> { strip_dashes(:manager_phone_number) }
  before_validation -> { strip_commas(:last_paycheck_amount) }

  validates_presence_of :company_name, message: "Please add a name."
  validates_presence_of :manager_name, message: "Please add a name."
  validates :manager_phone_number, ten_digit_phone_number: true
  validates :last_day, date: true
  validates :last_paycheck, date: true
  validates :last_paycheck_amount, numericality: {
    allow_nil: true,
    allow_blank: true,
    less_than: 100_000,
    message: "Please add a number.",
  }

  attr_internal_reader :last_day, :last_paycheck

  def save
    attributes = attributes_for(:change_report)
    attributes[:last_day] = to_datetime(last_day_year, last_day_month, last_day_day)
    attributes[:last_paycheck] = to_datetime(last_paycheck_year, last_paycheck_month, last_paycheck_day)
    change_report.update(attributes.except(
                           :last_day_year,
      :last_day_month,
      :last_day_day,
      :last_paycheck_year,
      :last_paycheck_month,
      :last_paycheck_day,
    ))
  end

  def self.existing_attributes(change_report)
    attributes = change_report.attributes
    %i[year month day].each do |sym|
      attributes["last_day_#{sym}"] = change_report.last_day.try(sym)
      attributes["last_paycheck_#{sym}"] = change_report.last_paycheck.try(sym)
    end
    HashWithIndifferentAccess.new(attributes)
  end
end
