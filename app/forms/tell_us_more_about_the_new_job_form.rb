class TellUsMoreAboutTheNewJobForm < Form
  set_attributes_for :change_report, :first_day_year, :first_day_month, :first_day_day, :paid_yet

  set_attributes_for :navigator, :street_address, :city, :zip_code

  validates_presence_of :paid_yet, message: "Please answer this question."
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
