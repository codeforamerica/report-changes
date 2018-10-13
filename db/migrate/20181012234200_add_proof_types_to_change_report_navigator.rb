class AddProofTypesToChangeReportNavigator < ActiveRecord::Migration[5.2]
  def change
    remove_column :change_report_navigators, :has_letter
    add_column :change_report_navigators, :proof_types, :string, array: true, default: []
  end
end
