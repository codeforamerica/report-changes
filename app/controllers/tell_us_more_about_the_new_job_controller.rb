class TellUsMoreAboutTheNewJobController < FormsController
  def self.show_rule_sets(report)
    super << report.reported_change.change_type_new_job?
  end
end
