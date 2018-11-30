class EmailChangeReportToOfficeJob < ApplicationJob
  def perform(report:)
    ApplicationMailer.office_change_report_submission(report).deliver
  end
end
