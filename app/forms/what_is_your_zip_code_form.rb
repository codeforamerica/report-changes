class WhatIsYourZipCodeForm < Form
  set_attributes_for :navigator, :zip_code

  validates :zip_code, length: { is: 5, message: "Please add a five digit ZIP code" }

  def save
    unless report.present?
      self.report = Report.create

      report.create_navigator
      report.create_metadata
    end

    report.navigator.update(attributes_for(:navigator))
    report.navigator.update(county: CountyFinder.from_zip_code(zip_code))
  end

  def self.existing_attributes(report)
    if report.present?
      HashWithIndifferentAccess.new(report.navigator.attributes)
    else
      {}
    end
  end
end
