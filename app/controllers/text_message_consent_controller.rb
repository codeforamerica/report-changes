class TextMessageConsentController < FormsController
  def self.show_rule_sets(change_report)
    super << change_report.submitting_for_self?
  end
end
