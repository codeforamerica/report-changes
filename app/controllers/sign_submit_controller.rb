class SignSubmitController < FormsController
  private

  def update_session
    EmailChangeReportToOfficeJob.perform_later(change_report: current_change_report)
  end
end
