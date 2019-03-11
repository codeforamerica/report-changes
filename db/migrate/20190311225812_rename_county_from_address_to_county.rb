class RenameCountyFromAddressToCounty < ActiveRecord::Migration[5.2]
  def change
    rename_column :navigators, :county_from_address, :county
  end
end
