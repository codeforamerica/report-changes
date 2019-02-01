class TellUsAboutTheNewJobForm < Form
  set_attributes_for :change, :company_name, :manager_name, :manager_phone_number

  before_validation -> { strip_dashes(:manager_phone_number) }

  validates_presence_of :company_name, message: "Please add a name."
  validates :manager_phone_number, ten_digit_phone_number: true, allow_blank: true

  def save
    report.current_change.update(attributes_for(:change))
  end

  def self.existing_attributes(report)
    HashWithIndifferentAccess.new(report.current_change.attributes)
  end
end
