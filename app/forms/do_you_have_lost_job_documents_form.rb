class DoYouHaveLostJobDocumentsForm < Form
  set_attributes_for :navigator, :has_job_termination_documents

  validates_presence_of :has_job_termination_documents, message: "Please answer this question."

  def save
    report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(report)
    HashWithIndifferentAccess.new(report.navigator.attributes)
  end
end
