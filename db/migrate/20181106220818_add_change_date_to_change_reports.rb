class AddChangeDateToChangeReports < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :change_date, :datetime
    add_column :change_reports, :change_in_hours_notes, :text
    change_column :change_reports, :new_job_notes, :text
  end
end
