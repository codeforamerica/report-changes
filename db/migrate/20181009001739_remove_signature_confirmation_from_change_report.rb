class RemoveSignatureConfirmationFromChangeReport < ActiveRecord::Migration[5.2]
  def change
    remove_column :change_reports, :signature_confirmation, :integer
  end
end
