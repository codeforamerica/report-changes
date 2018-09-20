class DoYouHaveALetterController < FormsController
  private

  def existing_attributes
    HashWithIndifferentAccess.new(current_change_report.navigator.attributes)
  end
end
