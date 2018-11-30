class CountyLocationController < FormsController
  skip_before_action :ensure_report_present

  def update_session
    session[:current_report_id] = @form.report.id
  end

  def form_params
    super.merge source: session[:source]
  end
end
