class AddChangeInHoursDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.has_change_in_hours_documents_yes? && report.reported_changes.where(change_type: "change_in_hours").last.documents.empty?)
  end
end
