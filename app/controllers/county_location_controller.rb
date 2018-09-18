class CountyLocationController < FormsController
  skip_before_action :ensure_change_report_present

  def update_models
    unless current_change_report.present?
      change_report = ChangeReport.create
      change_report.create_navigator
      session[:current_change_report_id] = change_report.id
    end
    current_change_report.navigator.update!(params_for(:navigator))
  end

  private

  def existing_attributes
    if current_change_report.present?
      {
        selected_county_location: current_change_report.navigator.selected_county_location,
      }
    else
      {
        selected_county_location: nil,
      }
    end
  end
end
