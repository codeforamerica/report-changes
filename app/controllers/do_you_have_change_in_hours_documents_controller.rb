class DoYouHaveChangeInHoursDocumentsController < FormsController
  def self.show_rule_sets(report)
    super << ShowRules.show_for_change_in_hours(report)
  end
end
