class SelfEmployedForm < Form
  set_attributes_for :navigator, :is_self_employed

  validates_presence_of :is_self_employed, message: "Please answer this question."

  def save
    report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(report)
    attributes = report.navigator.attributes
    HashWithIndifferentAccess.new(attributes)
  end
end
