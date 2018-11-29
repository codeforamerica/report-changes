class AddLetterController < FormsController
  def self.show_rule_sets(change_report)
    super << change_report.has_documents_yes?
  end
end
