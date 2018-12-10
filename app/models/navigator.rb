class Navigator < ActiveRecord::Base
  belongs_to :report

  enum selected_county_location: { unfilled: 0, arapahoe: 1, not_arapahoe: 2, not_sure: 3 },
       _prefix: :selected_county_location
  enum has_job_termination_documents: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_job_termination_documents
  enum has_new_job_documents: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_new_job_documents
  enum has_change_in_hours_documents: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_change_in_hours_documents
  enum submitting_for: { unfilled: 0, self: 1, other_member: 2 }, _prefix: :submitting_for
  enum is_self_employed: { unfilled: 0, yes: 1, no: 2 }, _prefix: :is_self_employed

  def supported_county?
    selected_county_location_arapahoe? || county_from_address == "Arapahoe County"
  end
end
