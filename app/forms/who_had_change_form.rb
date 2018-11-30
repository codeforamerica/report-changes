class WhoHadChangeForm < Form
  set_attributes_for :navigator, :submitting_for

  validates_presence_of :submitting_for

  def save
    report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(report)
    attributes = report.navigator.attributes
    HashWithIndifferentAccess.new(attributes)
  end
end
