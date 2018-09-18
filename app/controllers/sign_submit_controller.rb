class SignSubmitController < FormsController
  def update_models
    current_change_report.update(params_for(:change_report))
  end

  private

  def existing_attributes
    {
      signature: current_change_report.signature,
    }
  end
end
