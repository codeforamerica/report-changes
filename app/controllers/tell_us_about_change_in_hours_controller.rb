class TellUsAboutChangeInHoursController < FormsController
  def self.show_rule_sets(report)
    super << report.change_type_change_in_hours?
  end
end
