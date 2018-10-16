class ApplicationMailer < ActionMailer::Base
  layout "mailer"

  def office_change_report_submission(pdf:, client_name:)
    attachments[attachment_name(client_name)] = pdf

    mail(
      from: %("ReportChangesColorado" <#{ENV['SENDING_EMAIL_ADDRESS']}>),
      to: CredentialsHelper.county_email_address,
      subject: "A new change report from #{client_name} was submitted!",
    )
  end

  private

  def attachment_name(client_name)
    [
      DateTime.now.in_time_zone("America/Denver").strftime("%Y-%m-%d"),
      client_name,
      "Change Report.pdf",
    ].join("_").gsub(" ", "_")
  end
end
