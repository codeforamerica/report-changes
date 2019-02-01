class SelfEmployedForm < Form
  set_attributes_for :change_navigator, :is_self_employed

  validates_presence_of :is_self_employed, message: "Please answer this question."

  def save
    report.current_change.change_navigator.update(attributes_for(:change_navigator))
  end

  def self.existing_attributes(report)
    attributes = report.current_change.change_navigator.attributes
    HashWithIndifferentAccess.new(attributes)
  end
end
