class WantACopyForm < Form
  set_attributes_for :report_metadata, :email

  def save
    report.metadata.update(attributes_for(:report_metadata))
  end

  def self.existing_attributes(report)
    HashWithIndifferentAccess.new(report.metadata.attributes)
  end
end
