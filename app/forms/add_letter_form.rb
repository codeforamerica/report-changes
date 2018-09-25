class AddLetterForm < Form
  set_attributes_for :change_report, letters: []

  before_validation :no_blanks
  validates_presence_of :letters, message: "Please attach your letter."

  def save
    letters_to_attach = letters.reject do |letter_signed_id|
      change_report.letters.map(&:signed_id).include?(letter_signed_id)
    end
    change_report.letters.attach(letters_to_attach)
  end

  private

  def no_blanks
    self.letters = letters.reject(&:blank?) if letters.present?
  end
end
