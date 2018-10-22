class AddProofTypesToNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :change_report_navigators, :has_offer_letter, :integer, default: 0
    add_column :change_report_navigators, :has_paystub, :integer, default: 0
    rename_column :change_report_navigators, :has_letter, :has_termination_letter
  end
end
