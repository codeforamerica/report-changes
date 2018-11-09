class ClientNameForm < Form
  set_attributes_for :member, :first_name, :last_name

  validates_presence_of :first_name, message: "Please add your first name."
  validates_presence_of :last_name, message: "Please add your last name."

  def save
    if change_report.member.present?
      change_report.member.update(attributes_for(:member))
    else
      change_report.create_member(attributes_for(:member))
    end
  end

  def self.existing_attributes(change_report)
    if change_report.member.present?
      HashWithIndifferentAccess.new(change_report.member.attributes)
    else
      {}
    end
  end
end
