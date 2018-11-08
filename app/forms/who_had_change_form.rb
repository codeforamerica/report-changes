class WhoHadChangeForm < Form
  set_attributes_for :change_report, :submitting_for

  validates_presence_of :submitting_for

  def save
    change_report.update(attributes_for(:change_report))
  end
end
