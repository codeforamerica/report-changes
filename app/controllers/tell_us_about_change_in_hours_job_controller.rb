class TellUsAboutChangeInHoursJobController < FormsController
  def self.show_rule_sets(report)
    super << report.reported_change.change_type_change_in_hours?
  end
end
