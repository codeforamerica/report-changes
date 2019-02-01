class Navigator < ActiveRecord::Base
  belongs_to :report

  enum selected_county_location: { unfilled: 0, arapahoe: 1, not_arapahoe: 2, not_sure: 3 },
       _prefix: :selected_county_location
  enum submitting_for: { unfilled: 0, self: 1, other_member: 2 }, _prefix: :submitting_for

  def supported_county?
    selected_county_location_arapahoe? || county_from_address == "Arapahoe County"
  end
end
