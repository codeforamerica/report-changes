class ShowRules
  def self.defaults_to_true
    true
  end

  def self.must_not_know_county_location(change_report)
    change_report.navigator.selected_county_location_not_sure?
  end

  def self.must_have_entered_supported_county_address(change_report)
    change_report.navigator.county_from_address == "Arapahoe County"
  end

  def self.must_have_not_yet_supported_county(change_report)
    !change_report.navigator.supported_county?
  end
end
