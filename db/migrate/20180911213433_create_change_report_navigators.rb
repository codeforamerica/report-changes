class CreateChangeReportNavigators < ActiveRecord::Migration[5.2]
  def change
    create_table :change_report_navigators do |t|
      t.references :change_report
      t.integer :selected_county_location
      t.timestamps
    end

    change_column_default :change_report_navigators, :selected_county_location, from: nil, to: 0
  end
end
