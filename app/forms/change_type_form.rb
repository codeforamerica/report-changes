class ChangeTypeForm < Form
  set_attributes_for :report, :change_type

  validates_presence_of :change_type, message: "Please pick a change type."

  def save
    report.update(attributes_for(:report))
  end
end
