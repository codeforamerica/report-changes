class AddDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << report.current_change.change_navigator.has_documents_yes?
  end
end
