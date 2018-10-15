class AddWageInfoToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :hourly_wage, :string
    add_column :change_reports, :same_hours, :integer, default: 0
    add_column :change_reports, :paid_how_often, :string
    add_column :change_reports, :first_paycheck, :datetime
    add_column :change_reports, :new_job_notes, :string
    add_column :change_reports, :same_hours_a_week_amount, :string
    add_column :change_reports, :lower_hours_a_week_amount, :string
    add_column :change_reports, :upper_hours_a_week_amount, :string
  end
end
