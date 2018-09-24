class AddLetterForm < Form
  set_attributes_for :change_report, letters: []

  before_validation :no_blanks
  validates_presence_of :letters, message: "Please attach your letter."

  def save
    change_report.letters.attach(letters)
  end

  private

  def no_blanks
    self.letters = letters.reject(&:blank?) if letters.present?
  end
end
