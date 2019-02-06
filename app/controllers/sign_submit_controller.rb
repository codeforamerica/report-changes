class SignSubmitController < FormsController
  private

  def update_session
    unless Rails.env.demo?
      EmailChangeReportToOfficeJob.perform_later(report: current_report)

      if current_report.metadata.consent_to_sms_yes?
        TextConfirmationToClientJob.perform_later(phone_number: current_report.submitter.phone_number)
      end

      if current_report.metadata.email.present?
        EmailReportCopyToClientJob.perform_later(report: current_report)
      end
    end
  end
end
