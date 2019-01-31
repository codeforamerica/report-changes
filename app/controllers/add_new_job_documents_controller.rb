class AddNewJobDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.has_new_job_documents_yes? && report.reported_changes.where(change_type: "new_job").last.documents.empty?)
  end
end
