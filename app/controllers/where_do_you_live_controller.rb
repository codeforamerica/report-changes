class WhereDoYouLiveController < FormsController
  def self.skip_rule_sets(change_report)
    super << SkipRules.must_not_know_county_location(change_report)
  end

  def update_models
    current_change_report.navigator.update!(params_for(:navigator))
  end

  private

  def existing_attributes
    HashWithIndifferentAccess.new(current_change_report.navigator.attributes)
  end
end
