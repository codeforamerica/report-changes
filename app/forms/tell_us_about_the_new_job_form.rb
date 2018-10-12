class TellUsAboutTheNewJobForm < Form
  set_attributes_for :change_report, :company_name, :manager_name, :manager_phone_number,
    :first_day_year, :first_day_month, :first_day_day, :paid_yet

  before_validation -> { strip_dashes(:manager_phone_number) }

  validates_presence_of :company_name, message: "Please add a name."
  validates_presence_of :manager_name, message: "Please add a name."
  validates_presence_of :paid_yet, message: "Please answer this question."
  validates :manager_phone_number, ten_digit_phone_number: true
  validates :first_day, date: true

  attr_internal_reader :first_day

  def save
    attributes = attributes_for(:change_report)
    attributes[:first_day] = to_datetime(first_day_year, first_day_month, first_day_day)

    change_report.update(attributes.except(
                           :first_day_year,
      :first_day_month,
      :first_day_day,
    ))
  end

  def self.existing_attributes(change_report)
    attributes = change_report.attributes
    %i[year month day].each do |sym|
      attributes["first_day_#{sym}"] = change_report.first_day.try(sym)
    end
    HashWithIndifferentAccess.new(attributes)
  end
end
