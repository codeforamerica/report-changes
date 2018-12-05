class TellUsAboutTheLostJobController < FormsController
  def self.show_rule_sets(report)
    super << report.reported_change.change_type_job_termination?
  end
end
