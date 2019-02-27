class RemoveOldColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :changes, :report_id
    remove_column :navigators, :submitting_for, :integer, default: 0
    remove_column :reports, :phone_number, :string
    remove_column :reports, :case_number, :string
  end
end
