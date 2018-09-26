class EmployerContactInformationForm < Form
  set_attributes_for :change_report, :manager_name, :manager_phone_number, :manager_additional_information

  before_validation -> { strip_dashes(:manager_phone_number) }

  validates_presence_of :manager_name, message: "Please add a name."
  validates :manager_phone_number, ten_digit_phone_number: true

  def save
    change_report.update(attributes_for(:change_report))
  end
end
