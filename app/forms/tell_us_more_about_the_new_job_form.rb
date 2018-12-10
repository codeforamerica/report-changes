class TellUsMoreAboutTheNewJobForm < Form
  set_attributes_for :report, :first_day_year, :first_day_month, :first_day_day, :paid_yet

  validates_presence_of :paid_yet, message: "Please answer this question."
  validates :first_day, date: true

  attr_internal_reader :first_day

  def save
    attributes = attributes_for(:report)
    attributes[:first_day] = to_datetime(first_day_year, first_day_month, first_day_day)

    report.new_job_change.update(attributes.except(:first_day_year, :first_day_month, :first_day_day))
  end

  def self.existing_attributes(report)
    reported_change = report.new_job_change

    attributes = reported_change.attributes
    %i[year month day].each do |sym|
      attributes["first_day_#{sym}"] = reported_change.first_day.try(sym)
    end
    HashWithIndifferentAccess.new(attributes)
  end
end
