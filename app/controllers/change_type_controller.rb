class ChangeTypeController < FormsController
  def update_session
    session[:current_change_id] = @form.report.reported_changes.last.id
  end
end
