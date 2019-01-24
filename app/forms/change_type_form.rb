class ChangeTypeForm < Form
  set_attributes_for :change, :change_type

  validates_presence_of :change_type, message: "Choose one."

  def save
    change_type = attributes_for(:change)[:change_type]
    report.reported_changes.find_or_create_by(change_type: change_type)
  end
end
