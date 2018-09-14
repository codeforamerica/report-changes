class NotYetSupportedCountyController < FormsController
  def self.skip_rule_sets(change_report)
    super << SkipRules.must_have_not_yet_supported_county(change_report)
  end

  def form_class
    NullForm
  end
end
