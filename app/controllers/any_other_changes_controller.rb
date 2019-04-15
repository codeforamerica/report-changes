class AnyOtherChangesController < FormsController
  def update
    if form_params[:any_other_changes] == "yes"
      redirect_to change_type_screens_path
    else
      redirect_to(next_path)
    end
  end
end
