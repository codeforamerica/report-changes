class WaitUntilPaidController < FormsController
  def self.show_rule_sets(change_report)
    [
      change_report.change_type_new_job?,
      !change_report.paid_yet_yes?,
    ] + super
  end

  def form_class
    NullForm
  end
end
