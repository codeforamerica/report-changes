class ChangeTypeController < FormsController
  def next_path
    if params[:form][:change_type] == "job_termination"
      screen_path(TellUsAboutTheLostJobController.to_param)
    end
  end
end
