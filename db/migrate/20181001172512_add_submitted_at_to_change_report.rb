class AddSubmittedAtToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :submitted_at, :datetime
  end
end
