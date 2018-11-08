class EmailChangeReportToOfficeJob < ApplicationJob
  def perform(change_report:)
    ApplicationMailer.office_change_report_submission(
      pdf: ChangeReportPdfBuilder.new(change_report).run,
      client_name: ChangeReportDecorator.new(change_report).client_name,
    ).deliver
  end
end
