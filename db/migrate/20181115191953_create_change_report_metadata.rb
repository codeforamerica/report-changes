class CreateChangeReportMetadata < ActiveRecord::Migration[5.2]
  def change
    create_table :change_report_metadata do |t|
      t.integer "consent_to_sms", default: 0
      t.text "feedback_comments"
      t.integer "feedback_rating", default: 0
      t.references :change_report
      t.timestamps
    end
  end
end
