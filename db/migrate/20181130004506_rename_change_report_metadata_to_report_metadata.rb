class RenameChangeReportMetadataToReportMetadata < ActiveRecord::Migration[5.2]
  def change
    rename_table :change_report_metadata, :report_metadata
  end
end
