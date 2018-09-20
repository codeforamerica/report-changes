class DoYouHaveALetterForm < Form
  set_attributes_for :navigator, :has_letter

  validates_presence_of :has_letter, message: "Please answer this question."

  def save
    change_report.navigator.update(attributes_for(:navigator))
  end
end
