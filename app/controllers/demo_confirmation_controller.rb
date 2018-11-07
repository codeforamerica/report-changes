class DemoConfirmationController < FormsController
  layout "off_ramp"

  def self.show_rule_sets(change_report)
    super << GateKeeper.demo_environment?
  end

  skip_before_action :ensure_change_report_present

  def form_class
    NullForm
  end
end
