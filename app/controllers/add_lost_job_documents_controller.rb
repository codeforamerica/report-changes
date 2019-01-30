class AddLostJobDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.has_job_termination_documents_yes? && report.reported_changes.last.documents.empty?)
  end
end
