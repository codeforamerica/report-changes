class AddIsSelfEmployedToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :is_self_employed, :integer, default: 0
  end
end
