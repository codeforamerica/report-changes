class MembersNowHaveChangeReports < ActiveRecord::Migration[5.2]
  def change
    add_reference :change_reports, :household_member, index: true
  end
end
