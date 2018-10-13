class DoYouHaveALetterForm < Form
  set_attributes_for :navigator, proof_types: []

  validate :proof_types_allowed

  def save
    proof_types = attributes_for(:navigator)[:proof_types]
    change_report.navigator.update(proof_types: proof_types || [])
  end

  def self.existing_attributes(change_report)
    HashWithIndifferentAccess.new(change_report.navigator.attributes)
  end

  private

  def proof_types_allowed
    return true if proof_types.nil? || proof_types.empty?

    if (proof_types - ChangeReportNavigator::PROOF_TYPES.keys.map(&:to_s)).any?
      errors.add(:proof_types, "Please select an option.")
    end
  end
end
