class SignSubmitController < FormsController
  private

  def existing_attributes
    {
      signature: current_change_report.signature,
      signature_confirmation: current_change_report.signature_confirmation,
    }
  end
end
