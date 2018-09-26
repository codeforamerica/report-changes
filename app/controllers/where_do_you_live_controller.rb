class WhereDoYouLiveController < FormsController
  def self.show_rule_sets(change_report)
    super << change_report.navigator.selected_county_location_not_sure?
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(current_change_report.navigator.attributes)
  end
end
