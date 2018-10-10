class ChangeTypeForm < Form
  set_attributes_for :change_report, :change_type

  validates_presence_of :change_type, message: "Please pick a change type."

  def save
    change_report.update(attributes_for(:change_report))
  end
end
