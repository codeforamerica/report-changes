class SignSubmitController < FormsController
  private

  def update_session
    unless Rails.env.demo?
      EmailChangeReportToOfficeJob.perform_later(change_report: current_change_report)
    end
  end
end
