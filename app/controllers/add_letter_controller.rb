class AddLetterController < FormsController
  def self.show_rule_sets(change_report)
    super << change_report.navigator.documents_to_upload.present?
  end
end
