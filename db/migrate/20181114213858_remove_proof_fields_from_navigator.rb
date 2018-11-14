class RemoveProofFieldsFromNavigator < ActiveRecord::Migration[5.2]
  def change
    remove_column :change_report_navigators, :has_change_in_hours_letter, :integer, default: 0
    remove_column :change_report_navigators, :has_offer_letter, :integer, default: 0
    remove_column :change_report_navigators, :has_paystub, :integer, default: 0
    rename_column :change_report_navigators, :has_termination_letter, :has_documents
  end
end
