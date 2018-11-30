class DemoConfirmationController < FormsController
  layout "off_ramp"

  def self.show_rule_sets(report)
    super << GateKeeper.demo_environment?
  end

  skip_before_action :ensure_report_present

  def form_class
    NullForm
  end
end
