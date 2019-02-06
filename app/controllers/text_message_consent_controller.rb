class TextMessageConsentController < FormsController
  def self.show_rule_sets(report)
    super << report.submitter&.phone_number.present?
  end
end
