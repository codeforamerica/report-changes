class SelfEmployedController < FormsController
  def self.show_rule_sets(change_report)
    super << change_report.change_type_new_job?
  end
end
