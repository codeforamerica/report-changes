class CountyLocationController < FormsController
  skip_before_action :ensure_change_report_present

  def update_session
    session[:current_change_report_id] = @form.change_report.id
  end

  def form_params
    super.merge source: session[:source]
  end
end
