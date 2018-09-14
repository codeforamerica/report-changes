class ChangeReportNavigator < ActiveRecord::Base
  belongs_to :change_report

  enum selected_county_location: { unfilled: 0, arapahoe: 1, not_arapahoe: 2, not_sure: 3 },
       _prefix: :selected_county_location

  def supported_county?
    selected_county_location_arapahoe? || county_from_address == "Arapahoe County"
  end
end
