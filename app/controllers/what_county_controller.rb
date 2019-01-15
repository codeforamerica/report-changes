class WhatCountyController < FormsController
  def self.show_rule_sets(report)
    super << report.navigator.selected_county_location_not_arapahoe?
  end
end
