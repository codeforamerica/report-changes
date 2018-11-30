class TellUsAboutTheLostJobController < FormsController
  def self.show_rule_sets(report)
    super << report.change_type_job_termination?
  end
end
