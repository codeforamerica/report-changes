class MoveReportDataToChange < ActiveRecord::Migration[5.2]
  def up
    execute <<~SQL
      INSERT INTO changes (report_id, created_at, updated_at, change_date, change_in_hours_notes, change_type, company_name, first_day, first_paycheck, hourly_wage, last_day, last_paycheck, last_paycheck_amount, lower_hours_a_week_amount, manager_additional_information, manager_name, manager_phone_number, new_job_notes, paid_how_often, paid_yet, same_hours, same_hours_a_week_amount, upper_hours_a_week_amount)
            SELECT id, created_at, updated_at, change_date, change_in_hours_notes, change_type, company_name, first_day, first_paycheck, hourly_wage, last_day, last_paycheck, last_paycheck_amount, lower_hours_a_week_amount, manager_additional_information, manager_name, manager_phone_number, new_job_notes, paid_how_often, paid_yet, same_hours, same_hours_a_week_amount, upper_hours_a_week_amount
       FROM reports;
    SQL

    remove_column :reports, :change_date, :datetime
    remove_column :reports, :change_in_hours_notes, :text
    remove_column :reports, :change_type, :integer, default: 0
    remove_column :reports, :company_name, :string
    remove_column :reports, :first_day, :datetime
    remove_column :reports, :first_paycheck, :datetime
    remove_column :reports, :hourly_wage, :string
    remove_column :reports, :last_day, :datetime
    remove_column :reports, :last_paycheck, :datetime
    remove_column :reports, :last_paycheck_amount, :decimal, precision: 8, scale: 2
    remove_column :reports, :lower_hours_a_week_amount, :string
    remove_column :reports, :manager_additional_information, :string
    remove_column :reports, :manager_name, :string
    remove_column :reports, :new_job_notes, :text
    remove_column :reports, :paid_how_often, :string
    remove_column :reports, :paid_yet, :integer, default: 0
    remove_column :reports, :same_hours, :integer, default: 0
    remove_column :reports, :same_hours_a_week_amount, :string
    remove_column :reports, :upper_hours_a_week_amount, :string
  end

  def down
    add_column :reports, :change_date, :datetime
    add_column :reports, :change_in_hours_notes, :text
    add_column :reports, :change_type, :integer, default: 0
    add_column :reports, :company_name, :string
    add_column :reports, :first_day, :datetime
    add_column :reports, :first_paycheck, :datetime
    add_column :reports, :hourly_wage, :string
    add_column :reports, :last_day, :datetime
    add_column :reports, :last_paycheck, :datetime
    add_column :reports, :last_paycheck_amount, :decimal, precision: 8, scale: 2
    add_column :reports, :lower_hours_a_week_amount, :string
    add_column :reports, :manager_additional_information, :string
    add_column :reports, :manager_name, :string
    add_column :reports, :new_job_notes, :text
    add_column :reports, :paid_how_often, :string
    add_column :reports, :paid_yet, :integer, default: 0
    add_column :reports, :same_hours, :integer, default: 0
    add_column :reports, :same_hours_a_week_amount, :string
    add_column :reports, :upper_hours_a_week_amount, :string

    execute <<~SQL
      UPDATE reports SET (change_date, change_in_hours_notes, change_type, company_name, first_day, first_paycheck, hourly_wage, last_day, last_paycheck, last_paycheck_amount, lower_hours_a_week_amount, manager_additional_information, manager_name, manager_phone_number, new_job_notes, paid_how_often, paid_yet, phone_number, same_hours, same_hours_a_week_amount, upper_hours_a_week_amount) =

      ( SELECT change_date, change_in_hours_notes, change_type, company_name, first_day, first_paycheck, hourly_wage, last_day, last_paycheck, last_paycheck_amount, lower_hours_a_week_amount, manager_additional_information, manager_name, manager_phone_number, new_job_notes, paid_how_often, paid_yet, phone_number, same_hours, same_hours_a_week_amount, upper_hours_a_week_amount

      FROM changes

      WHERE changes.report_id = reports.id );
    SQL
  end
end
