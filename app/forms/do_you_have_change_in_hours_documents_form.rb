class DoYouHaveChangeInHoursDocumentsForm < Form
  set_attributes_for :navigator, :has_change_in_hours_documents

  validates_presence_of :has_change_in_hours_documents, message: "Please answer this question."

  def save
    report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(report)
    HashWithIndifferentAccess.new(report.navigator.attributes)
  end
end
