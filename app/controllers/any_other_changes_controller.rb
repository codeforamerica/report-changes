class AnyOtherChangesController < FormsController
  def self.show_rule_sets(report)
    super << report.unreported_change_types.present?
  end

  def update
    if form_params[:any_other_changes] == "yes"
      redirect_to change_type_screens_path
    else
      redirect_to(next_path)
    end
  end
end
