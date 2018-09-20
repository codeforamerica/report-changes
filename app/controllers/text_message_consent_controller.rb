class TextMessageConsentController < FormsController
  helper_method :current_change_report

  private

  def existing_attributes
    {
      consent_to_sms: current_change_report.consent_to_sms,
    }
  end
end
