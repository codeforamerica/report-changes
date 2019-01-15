class AddWhatCountyToMetadata < ActiveRecord::Migration[5.2]
  def change
    add_column :report_metadata, :what_county, :string
  end
end
