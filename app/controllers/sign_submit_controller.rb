class SignSubmitController < FormsController
  private

  def existing_attributes
    {
      signature: current_change_report.signature,
    }
  end
end
