class AddChangeTypeToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :change_type, :integer
    change_column_default :change_reports, :change_type, from: nil, to: 0
  end
end
