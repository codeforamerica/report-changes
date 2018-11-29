class DoYouHaveALetterForm < Form
  set_attributes_for :change_report, :has_documents

  validates_presence_of :has_documents, message: "Please answer this question."

  def save
    change_report.update(attributes_for(:change_report))
  end
end
