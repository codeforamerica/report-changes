class AddNewJobDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.has_new_job_documents_yes? && report.new_job_change.documents.empty?)
  end
end
