class ShowRules
  def self.defaults_to_true
    true
  end

  def self.show_for_job_termination(report)
    !!report.job_termination_change&.show?
  end

  def self.show_for_new_job(report)
    !!report.new_job_change&.show?
  end

  def self.show_for_change_in_hours(report)
    !!report.change_in_hours_change&.show?
  end
end
