class DoYouHaveDocumentsForm < Form
  set_attributes_for :change_navigator, :has_documents

  validates_presence_of :has_documents, message: "Please answer this question."

  def save
    report.current_change.change_navigator.update(attributes_for(:change_navigator))
  end

  def self.existing_attributes(report)
    HashWithIndifferentAccess.new(report.current_change.change_navigator.attributes)
  end
end
