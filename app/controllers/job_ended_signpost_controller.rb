class JobEndedSignpostController < FormsController
  layout "sign_post"

  def self.show_rule_sets(report)
    [
      ShowRules.show_for_job_termination(report),
      report.reported_changes.count >= 2,
    ]
  end

  def form_class
    NullForm
  end
end
