class AddCountyFromAddressToChangeReportNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :change_report_navigators, :county_from_address, :string
  end
end
