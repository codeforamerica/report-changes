class AddDocumentsForm < Form
  set_attributes_for :change, letters: []

  def save
    self.letters ||= []
    letters_to_attach = letters.reject do |letter_signed_id|
      letter_signed_id.blank? ||
        report.reported_changes.last.documents.map(&:signed_id).include?(letter_signed_id)
    end
    report.reported_changes.last.documents.attach(letters_to_attach)
    report.reported_changes.last.documents.each do |letter|
      letter.delete if letters.exclude?(letter.signed_id)
    end
  end

  def self.existing_attributes(report)
    {
      letters: report.reported_changes.last.documents,
    }
  end

  delegate :change_type, to: :class
end
