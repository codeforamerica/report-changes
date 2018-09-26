class CountyLocationForm < Form
  set_attributes_for :navigator, :selected_county_location

  validates_presence_of :selected_county_location,
    message: "Please answer this question"

  def save
    unless change_report.present?
      self.change_report = ChangeReport.create
      change_report.create_navigator
    end

    change_report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(change_report)
    if change_report.present?
      HashWithIndifferentAccess.new(change_report.navigator.attributes)
    else
      {}
    end
  end
end
