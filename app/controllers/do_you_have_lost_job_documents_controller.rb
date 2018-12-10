class DoYouHaveLostJobDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << ShowRules.show_for_job_termination(report)
  end
end
