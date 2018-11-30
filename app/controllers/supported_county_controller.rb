class SupportedCountyController < FormsController
  layout "sign_post"

  def self.show_rule_sets(report)
    super << (report.navigator.county_from_address == "Arapahoe County")
  end

  def form_class
    NullForm
  end
end
