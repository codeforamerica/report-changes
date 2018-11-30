class RenameChangeReportNavigatorToNavigator < ActiveRecord::Migration[5.2]
  def change
    rename_table :change_report_navigators, :navigators
  end
end
