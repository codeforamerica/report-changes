class WhereDoYouLiveController < FormsController
  def self.show_rule_sets(report)
    super << report.navigator.selected_county_location_not_sure?
  end
end
