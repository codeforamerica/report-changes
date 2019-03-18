class OverlappingZipCodeController < FormsController
  def self.show_rule_sets(report)
    super << (report.navigator.overlapping_zip? && report.navigator.zip_code_includes_supported_county?)
  end

  helper_method :overlapping_county_collection

  def overlapping_county_collection
    CountyService::ZIP_CODE_COUNTIES[current_report.navigator.zip_code].map do |county|
      { value: county, label: "#{county} County" }
    end
  end
end
