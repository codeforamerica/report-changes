class AddDocumentsForm < Form
  set_attributes_for :change, documents: []

  def save
    self.documents ||= []
    documents_to_attach = documents.reject do |document_signed_id|
      document_signed_id.blank? ||
        report.current_change.documents.map(&:signed_id).include?(document_signed_id)
    end
    report.current_change.documents.attach(documents_to_attach)
    report.current_change.documents.each do |document|
      document.delete if documents.exclude?(document.signed_id)
    end
  end

  def self.existing_attributes(report)
    {
      documents: report.current_change.documents,
    }
  end

  delegate :change_type, to: :class
end
