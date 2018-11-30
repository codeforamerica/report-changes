class SignSubmitForm < Form
  set_attributes_for :report, :signature

  validates_presence_of :signature,
    message: "Make sure you enter your full legal name"

  def save
    report.update(attributes_for(:report).merge(submitted_at: Time.zone.now))
  end
end
