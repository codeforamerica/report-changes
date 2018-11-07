class AddHasChangeInHoursLetterToChangeReportNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :change_report_navigators, :has_change_in_hours_letter, :integer, default: 0
  end
end
