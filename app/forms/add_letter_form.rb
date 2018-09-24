class AddLetterForm < Form
  set_attributes_for :change_report, letters: []

  validates_presence_of :letters, message: "Please attach your letter."

  def save
    change_report.letters.attach(letters.reject(&:blank?))
  end
end
