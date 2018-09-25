class AddLetterForm < Form
  set_attributes_for :change_report, letters: []

  def save
    letters_to_attach = letters.reject do |letter_signed_id|
      letter_signed_id.blank? ||
        change_report.letters.map(&:signed_id).include?(letter_signed_id)
    end
    change_report.letters.attach(letters_to_attach)
    change_report.letters.each do |letter|
      letter.delete if letters.exclude?(letter.signed_id)
    end
  end
end
