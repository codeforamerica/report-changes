class CountyLocationForm < Form
  set_attributes_for :navigator, :selected_county_location, :source

  validates_presence_of :selected_county_location,
    message: "Please answer this question"

  def save
    unless change_report.present?
      self.change_report = ChangeReport.create

      while_feature_flag_set_default_type

      change_report.create_navigator
      change_report.create_metadata
    end

    change_report.navigator.update(attributes_for(:navigator))
  end

  def self.existing_attributes(change_report)
    if change_report.present?
      HashWithIndifferentAccess.new(change_report.navigator.attributes)
    else
      {}
    end
  end

  private

  def while_feature_flag_set_default_type
    unless GateKeeper.feature_enabled?("NEW_JOB_FLOW")
      change_report.update(change_type: :job_termination)
    end
  end
end
