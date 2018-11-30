class TextMessageConsentForm < Form
  set_attributes_for :metadata, :consent_to_sms

  def save
    report.metadata.update(attributes_for(:metadata))
  end

  def self.existing_attributes(report)
    attributes = report.metadata.attributes
    HashWithIndifferentAccess.new(attributes)
  end
end
