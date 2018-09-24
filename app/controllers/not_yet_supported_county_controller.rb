class NotYetSupportedCountyController < FormsController
  def self.show_rule_sets(change_report)
    super << !change_report.navigator.supported_county?
  end

  def form_class
    NullForm
  end
end
