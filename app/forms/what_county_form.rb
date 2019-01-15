class WhatCountyForm < Form
  set_attributes_for :metadata, :what_county

  def save
    report.metadata.update(attributes_for(:metadata))
  end

  def self.existing_attributes(report)
    HashWithIndifferentAccess.new(report.metadata.attributes)
  end
end
