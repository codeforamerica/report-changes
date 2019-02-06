class ChangeTypeController < FormsController
  def update_session
    # clear out current member and change
    current_report.navigator.update(current_member_id: nil, current_change_id: nil)
  end
end
