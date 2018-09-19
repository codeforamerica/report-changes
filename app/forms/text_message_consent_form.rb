class TextMessageConsentForm < Form
  set_attributes_for :change_report, :consent_to_sms, :phone_number

  def save
    change_report.update(
      consent_to_sms: consent_to_sms,
    )
  end
end
