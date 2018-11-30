class CountyLocationForm < Form
  set_attributes_for :navigator, :selected_county_location, :source

  validates_presence_of :selected_county_location,
    message: "Please answer this question"

  def save
    unless report.present?
      self.report = Report.create

      report.create_navigator
      report.create_metadata
    end

    report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(report)
    if report.present?
      HashWithIndifferentAccess.new(report.navigator.attributes)
    else
      {}
    end
  end
end
