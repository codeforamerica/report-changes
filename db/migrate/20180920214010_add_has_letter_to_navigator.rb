class AddHasLetterToNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :change_report_navigators, :has_letter, :integer
    change_column_default :change_report_navigators, :has_letter, from: nil, to: 0
  end
end
