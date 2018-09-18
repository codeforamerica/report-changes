class CountyLocationForm < Form
  set_attributes_for :navigator, :selected_county_location

  validates_presence_of :selected_county_location,
    message: "Please answer this question"

  def save
    unless change_report.present?
      self.change_report = ChangeReport.create
      change_report.create_navigator
    end

    change_report.navigator.update(selected_county_location: selected_county_location)
  end
end
