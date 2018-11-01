class NotYetSupportedController < FormsController
  def self.show_rule_sets(change_report)
    super << (!change_report.navigator.supported_county? || change_report.is_self_employed_yes?)
  end

  def form_class
    NullForm
  end

  def layout
    "off_ramp"
  end
end
