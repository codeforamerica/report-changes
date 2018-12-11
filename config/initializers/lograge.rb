Rails.application.configure do
  config.lograge.enabled = true

  config.lograge.custom_payload do |controller|
    {
      report_id: report_id(controller),
      admin_user_email: controller.try(:current_admin_user).try(:email),
    }
  end

  def report_id(controller)
    params = controller.params
    if params[:controller] == "admin/reports" && params[:id]
      params[:id]
    elsif params[:controller] ==  "admin/changes" && params[:id]
      Change.find(params[:id]).report.id
    else
      controller.try(:current_report).try(:id)
    end
  end
end
