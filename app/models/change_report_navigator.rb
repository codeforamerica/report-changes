class ChangeReportNavigator < ActiveRecord::Base
  belongs_to :change_report

  enum selected_county_location: { unfilled: 0, arapahoe: 1, not_arapahoe: 2, not_sure: 3 },
       _prefix: :selected_county_location
  enum has_termination_letter: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_termination_letter
  enum has_offer_letter: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_offer_letter
  enum has_paystub: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_paystub

  def supported_county?
    selected_county_location_arapahoe? || county_from_address == "Arapahoe County"
  end

  def documents_to_upload
    return :termination_letter if has_termination_letter_yes?
    return :offer_letter_and_paystub if has_offer_letter_yes? && has_paystub_yes?
    return :offer_letter if has_offer_letter_yes?

    :paystub if has_paystub_yes?
  end
end
