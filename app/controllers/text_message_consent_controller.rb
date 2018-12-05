class TextMessageConsentController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.submitting_for_self? && report.phone_number.present?)
  end
end
