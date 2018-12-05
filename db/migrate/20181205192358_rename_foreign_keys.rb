class RenameForeignKeys < ActiveRecord::Migration[5.2]
  def change
    remove_index :household_members, :change_report_id
    remove_index :navigators, :change_report_id
    remove_index :report_metadata, :change_report_id

    rename_column :household_members, :change_report_id, :report_id
    rename_column :navigators, :change_report_id, :report_id
    rename_column :report_metadata, :change_report_id, :report_id

    add_index :household_members, :report_id
    add_index :navigators, :report_id
    add_index :report_metadata, :report_id
  end
end
