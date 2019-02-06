class ChangeTypeForm < Form
  set_attributes_for :navigator, :temp_change_type

  validates_presence_of :temp_change_type, message: "Choose one."

  def save
    report.navigator.update(attributes_for(:navigator))
  end
end
