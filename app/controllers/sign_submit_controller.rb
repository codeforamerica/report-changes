class SignSubmitController < FormsController
  private

  def update_session
    unless Rails.env.demo?
      EmailChangeReportToOfficeJob.perform_later(report: current_report)
    end
  end
end
