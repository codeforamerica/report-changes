class AddLetterForm < Form
  set_attributes_for :report, letters: []

  def save
    self.letters ||= []
    letters_to_attach = letters.reject do |letter_signed_id|
      letter_signed_id.blank? ||
        report.letters.map(&:signed_id).include?(letter_signed_id)
    end
    report.letters.attach(letters_to_attach)
    report.letters.each do |letter|
      letter.delete if letters.exclude?(letter.signed_id)
    end
  end

  def self.existing_attributes(report)
    {
      letters: report.letters,
    }
  end
end
