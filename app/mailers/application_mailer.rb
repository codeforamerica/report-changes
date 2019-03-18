class ApplicationMailer < ActionMailer::Base
  layout "mailer"

  def office_change_report_submission(report)
    report = ReportDecorator.new(report)
    attachments[attachment_name(report.signature)] = ReportPdfBuilder.new(report).run

    mail(
      from: %("ReportChangesColorado" <#{ENV['SENDING_EMAIL_ADDRESS']}>),
      to: CountyService.email_address(report),
      subject: "A new change report from #{report.signature} was submitted!",
    )
  end

  def report_copy_to_client(report)
    report = ReportDecorator.new(report)
    attachments[attachment_name(report.signature)] = ReportPdfBuilder.new(report).run

    mail(
      from: %("ReportChangesColorado" <#{ENV['SENDING_EMAIL_ADDRESS']}>),
      to: report.metadata.email,
      subject: "The requested copy of your change report.",
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
