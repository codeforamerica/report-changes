class TextMessageConsentForm < Form
  set_attributes_for :metadata, :consent_to_sms

  def save
    change_report.metadata.update(attributes_for(:metadata))
  end

  def self.existing_attributes(change_report)
    attributes = change_report.metadata.attributes
    HashWithIndifferentAccess.new(attributes)
  end
end
