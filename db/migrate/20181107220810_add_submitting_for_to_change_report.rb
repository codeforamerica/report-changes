class AddSubmittingForToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :submitting_for, :integer, default: 0
  end
end
