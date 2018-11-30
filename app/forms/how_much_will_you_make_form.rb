class HowMuchWillYouMakeForm < Form
  set_attributes_for :report, :hourly_wage, :same_hours, :paid_how_often,
    :first_paycheck_day, :first_paycheck_month, :first_paycheck_year, :new_job_notes,
    :same_hours_a_week_amount, :lower_hours_a_week_amount, :upper_hours_a_week_amount

  validates_presence_of :hourly_wage, message: "Please add a number."
  validates_presence_of :same_hours, message: "Please choose one."
  validates_presence_of :paid_how_often, message: "Please add an answer"
  validates :first_paycheck, date: true

  validate :same_hours_amounts

  attr_internal_reader :first_paycheck

  def save
    attributes = attributes_for(:report)
    attributes[:first_paycheck] = to_datetime(first_paycheck_year, first_paycheck_month, first_paycheck_day)

    report.update(filter_attributes(attributes))
  end

  def self.existing_attributes(report)
    attributes = report.attributes
    %i[year month day].each do |sym|
      attributes["first_paycheck_#{sym}"] = report.first_paycheck.try(sym)
    end
    HashWithIndifferentAccess.new(attributes)
  end

  private

  def same_hours_amounts
    case same_hours
    when "yes"
      validates_presence_of :same_hours_a_week_amount, message: "Please add a number."
    when "no"
      validates_presence_of :lower_hours_a_week_amount, :upper_hours_a_week_amount, message: "Please add a range."
    end
  end

  def filter_attributes(attributes)
    case same_hours
    when "yes"
      attributes[:lower_hours_a_week_amount] = nil
      attributes[:upper_hours_a_week_amount] = nil
    when "no"
      attributes[:same_hours_a_week_amount] = nil
    end

    attributes.except(
      :first_paycheck_year,
      :first_paycheck_month,
      :first_paycheck_day,
    )
  end
end
