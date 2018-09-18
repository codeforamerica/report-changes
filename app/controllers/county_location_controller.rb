class CountyLocationController < FormsController
  skip_before_action :ensure_change_report_present

  def update_session
    session[:current_change_report_id] = @form.change_report.id
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
