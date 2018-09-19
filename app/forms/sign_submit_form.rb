class SignSubmitForm < Form
  set_attributes_for :change_report, :signature, :signature_confirmation

  validates_presence_of :signature,
    message: "Make sure you enter your full legal name"

  validates :signature_confirmation,
    acceptance: {
      accept: ["yes"],
      message: "Please check the box to proceed",
    }

  def save
    change_report.update(
      signature: signature,
      signature_confirmation: signature_confirmation,
    )
  end
end
