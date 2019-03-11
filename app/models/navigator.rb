class Navigator < ActiveRecord::Base
  belongs_to :report
  belongs_to :current_member, class_name: "Member", foreign_key: "current_member_id", optional: true
  belongs_to :current_change, class_name: "Change", foreign_key: "current_change_id", optional: true

  enum selected_county_location: { unfilled: 0, arapahoe: 1, not_arapahoe: 2, not_sure: 3 },
       _prefix: :selected_county_location
  enum submitting_for: { unfilled: 0, self: 1, other_member: 2 }, _prefix: :submitting_for
  enum selected_change_type: { unfilled: 0, job_termination: 1, new_job: 2, change_in_hours: 3 },
       _prefix: :selected_change_type

  def supported_county?
    CountyFinder::VALID_COUNTIES.include? county
  end
end
