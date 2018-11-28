class CountyLocationForm < Form
  set_attributes_for :navigator, :selected_county_location, :source

  validates_presence_of :selected_county_location,
    message: "Please answer this question"

  def save
    unless change_report.present?
      self.household_member = HouseholdMember.create
      self.change_report = household_member.change_reports.create

      change_report.create_navigator
      change_report.create_metadata
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
