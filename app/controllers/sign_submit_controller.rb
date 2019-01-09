class SignSubmitController < FormsController
  private

  def update_session
    unless Rails.env.demo?
      EmailChangeReportToOfficeJob.perform_later(report: current_report)

      if current_report.metadata.consent_to_sms_yes?
        TextConfirmationToClientJob.perform_later(phone_number: current_report.phone_number)
      end
    end
  end
end
