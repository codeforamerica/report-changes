class TextMessageConsentForm < Form
  set_attributes_for :change_report, :consent_to_sms

  def save
    change_report.update(attributes_for(:change_report))
  end
end
