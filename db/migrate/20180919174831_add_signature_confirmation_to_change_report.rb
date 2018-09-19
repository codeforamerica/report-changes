class AddSignatureConfirmationToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :signature_confirmation, :integer
    change_column_default :change_reports, :signature_confirmation, from: nil, to: 0
  end
end
