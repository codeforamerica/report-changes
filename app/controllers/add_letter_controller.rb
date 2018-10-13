class AddLetterController < FormsController
  def self.show_rule_sets(change_report)
    rules = [
      change_report.navigator.proof_types.any?,
      change_report.change_type_job_termination?,
    ]
    super + rules
  end
end
