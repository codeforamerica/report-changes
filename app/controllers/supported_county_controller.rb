class SupportedCountyController < FormsController
  def self.show_rule_sets(change_report)
    super << (change_report.navigator.county_from_address == "Arapahoe County")
  end

  def form_class
    NullForm
  end

  def layout
    "sign_post"
  end
end
