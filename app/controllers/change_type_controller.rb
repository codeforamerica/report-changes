class ChangeTypeController < FormsController
  def self.show_rule_sets(_change_report)
    super << GateKeeper.feature_enabled?("NEW_JOB_FLOW")
  end
end
