class SkipRules
  def self.must_not_know_county_location(change_report)
    true unless change_report.navigator.selected_county_location_not_sure?
  end
end
