class ClientNameForm < Form
  set_attributes_for :member, :first_name, :last_name

  validates_presence_of :first_name, message: "Please add your first name."
  validates_presence_of :last_name, message: "Please add your last name."

  def save
    if report.member.present?
      report.member.update(attributes_for(:member))
    else
      report.create_member(attributes_for(:member))
    end
  end

  def self.existing_attributes(report)
    if report.member.present?
      HashWithIndifferentAccess.new(report.member.attributes)
    else
      {}
    end
  end
end
