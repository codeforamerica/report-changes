class AddLetterController < FormsController
  def self.show_rule_sets(change_report)
    super << change_report.navigator.has_letter_yes?
  end

  private

  def existing_attributes
    {
      letters: current_change_report.letters,
    }
  end
end
