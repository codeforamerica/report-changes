class SignSubmitForm < Form
  set_attributes_for :change_report, :signature, :signature_confirmation

  validates_presence_of :signature,
    message: "Make sure you enter your full legal name"

  validates_presence_of :signature_confirmation, message: "Please check the box to proceed."

  def save
    change_report.update(attributes_for(:change_report))
  end
end
