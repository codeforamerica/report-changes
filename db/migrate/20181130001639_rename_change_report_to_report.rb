class RenameChangeReportToReport < ActiveRecord::Migration[5.2]
  def change
    rename_table :change_reports, :reports
  end
end
