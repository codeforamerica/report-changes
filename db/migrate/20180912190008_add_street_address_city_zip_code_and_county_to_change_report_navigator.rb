class AddStreetAddressCityZipCodeAndCountyToChangeReportNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :change_report_navigators, :street_address, :string
    add_column :change_report_navigators, :city, :string
    add_column :change_report_navigators, :zip_code, :string
  end
end
