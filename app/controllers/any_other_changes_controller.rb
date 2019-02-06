class AnyOtherChangesController < FormsController
  def update
    if form_params[:any_other_changes] == "yes"
      redirect_to change_type_screens_path
    else
      # clear out current member and change
      current_report.navigator.update(current_member_id: nil, current_change_id: nil)

      redirect_to(next_path)
    end
  end
end
