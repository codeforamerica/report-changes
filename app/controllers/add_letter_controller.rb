class AddLetterController < FormsController
  def self.show_rule_sets(change_report)
    rules = [
      change_report.navigator.has_termination_letter_yes?,
      change_report.change_type_job_termination?,
    ]
    super + rules
  end
end
