class WhereDoYouLiveController < FormsController
  def self.show_rule_sets(change_report)
    super << ShowRules.must_not_know_county_location(change_report)
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(current_change_report.navigator.attributes)
  end
end
