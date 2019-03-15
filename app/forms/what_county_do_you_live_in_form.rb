class WhatCountyDoYouLiveInForm < Form
  set_attributes_for :report, :county

  validates_presence_of :county

  def save
    unless report.present?
      self.report = Report.create

      report.create_navigator
      report.create_metadata
    end

    report.update(attributes_for(:report))
  end

  def self.existing_attributes(report)
    if report.present?
      HashWithIndifferentAccess.new(report.attributes)
    else
      {}
    end
  end
end
