class ChangeTypeForm < Form
  set_attributes_for :change, :change_type

  validates_presence_of :change_type, message: "Choose one."

  def save
    change_type = attributes_for(:change)[:change_type]
    change = report.reported_changes.create change_type: change_type
    change.create_change_navigator
  end
end
