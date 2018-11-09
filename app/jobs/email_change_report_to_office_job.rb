class EmailChangeReportToOfficeJob < ApplicationJob
  def perform(change_report:)
    ApplicationMailer.office_change_report_submission(change_report).deliver
  end
end
