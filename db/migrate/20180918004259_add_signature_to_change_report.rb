class AddSignatureToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :signature, :string
  end
end
