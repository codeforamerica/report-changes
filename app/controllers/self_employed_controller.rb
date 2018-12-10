class SelfEmployedController < FormsController
  def self.show_rule_sets(report)
    super << ShowRules.show_for_new_job(report)
  end
end
