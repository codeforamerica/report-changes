class TextMessageConsentController < FormsController
  private

  def existing_attributes
    {
      consent_to_sms: current_change_report.consent_to_sms,
      phone_number: current_change_report.phone_number,
    }
  end
end
