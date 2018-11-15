class MoveFieldsFromChangeReportToNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :change_report_navigators, :submitting_for, :integer, default: 0
    add_column :change_report_navigators, :is_self_employed, :integer, default: 0
  end
end
