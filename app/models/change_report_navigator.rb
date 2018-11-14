class ChangeReportNavigator < ActiveRecord::Base
  belongs_to :change_report

  enum selected_county_location: { unfilled: 0, arapahoe: 1, not_arapahoe: 2, not_sure: 3 },
       _prefix: :selected_county_location
  enum has_documents: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_documents

  def supported_county?
    selected_county_location_arapahoe? || county_from_address == "Arapahoe County"
  end
end
