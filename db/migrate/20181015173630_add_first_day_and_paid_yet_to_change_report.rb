class AddFirstDayAndPaidYetToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :first_day, :datetime
    add_column :change_reports, :paid_yet, :integer, default: 0
  end
end
