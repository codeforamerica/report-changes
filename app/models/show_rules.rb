class ShowRules
  def self.defaults_to_true
    true
  end

  def self.show_for_job_termination(report)
    report.current_change.change_type == "job_termination"
  end

  def self.show_for_new_job(report)
    report.current_change.change_type == "new_job"
  end

  def self.show_for_change_in_hours(report)
    report.current_change.change_type == "change_in_hours"
  end
end
