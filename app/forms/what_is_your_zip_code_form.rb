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

    counties = CountyService::ZIP_CODE_COUNTIES.fetch(zip_code, [])
    if counties.length == 1
      report.update(county: counties.first)
    end
  end

  def self.existing_attributes(report)
    if report.present?
      HashWithIndifferentAccess.new(report.navigator.attributes)
    else
      {}
    end
  end
end
