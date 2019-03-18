class OverlappingZipCodeForm < Form
  set_attributes_for :report, :county

  validates_presence_of :county, message: "Please choose a county"

  def save
    report.update(attributes_for(:report))
  end
end
