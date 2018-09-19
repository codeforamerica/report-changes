class AddConsentToSmsToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :consent_to_sms, :integer
    change_column_default :change_reports, :consent_to_sms, from: nil, to: 0
  end
end
