class AddLetterController < FormsController
  def self.show_rule_sets(report)
    super << report.navigator.has_documents_yes?
  end
end
