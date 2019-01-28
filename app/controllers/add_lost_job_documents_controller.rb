class AddLostJobDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.has_job_termination_documents_yes? && report.job_termination_change.documents.empty?)
  end
end
