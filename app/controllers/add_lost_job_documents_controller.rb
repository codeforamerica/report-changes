class AddLostJobDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.has_job_termination_documents_yes? && report.reported_changes.where(change_type: "job_termination").last.documents.empty?)
  end
end
