class AddSourceToNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :change_report_navigators, :source, :string
  end
end
