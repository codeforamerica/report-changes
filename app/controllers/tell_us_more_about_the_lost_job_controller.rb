class TellUsMoreAboutTheLostJobController < FormsController
  def self.show_rule_sets(change_report)
    super << change_report.change_type_job_termination?
  end
end
