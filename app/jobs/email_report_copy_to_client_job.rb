class EmailReportCopyToClientJob < ApplicationJob
  def perform(report:)
    ApplicationMailer.report_copy_to_client(report).deliver
  end
end
