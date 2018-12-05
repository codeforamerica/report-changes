class ChangeTypeForm < Form
  set_attributes_for :change, :change_type

  validates_presence_of :change_type, message: "Please pick a change type."

  def save
    report.create_reported_change unless report.reported_change.present?

    report.reported_change.update(attributes_for(:change))
  end

  def self.existing_attributes(report)
    HashWithIndifferentAccess.new(report.reported_change&.attributes)
  end
end
