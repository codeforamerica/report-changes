class SelfEmployedForm < Form
  set_attributes_for :change_report, :is_self_employed

  validates_presence_of :is_self_employed, message: "Please answer this question."

  def save
    change_report.update(attributes_for(:change_report))
  end
end
