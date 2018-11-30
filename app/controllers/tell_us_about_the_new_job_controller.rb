class TellUsAboutTheNewJobController < FormsController
  def self.show_rule_sets(report)
    super << report.change_type_new_job?
  end
end
