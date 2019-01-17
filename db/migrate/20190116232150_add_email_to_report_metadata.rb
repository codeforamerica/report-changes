class AddEmailToReportMetadata < ActiveRecord::Migration[5.2]
  def change
    add_column :report_metadata, :email, :string
  end
end
