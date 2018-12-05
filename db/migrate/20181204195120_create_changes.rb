class CreateChanges < ActiveRecord::Migration[5.2]
  def change
    create_table :changes do |t|
      t.datetime "change_date"
      t.text "change_in_hours_notes"
      t.integer "change_type", default: 0
      t.string "company_name"
      t.datetime "first_day"
      t.datetime "first_paycheck"
      t.string "hourly_wage"
      t.datetime "last_day"
      t.datetime "last_paycheck"
      t.decimal "last_paycheck_amount", precision: 8, scale: 2
      t.string "lower_hours_a_week_amount"
      t.string "manager_additional_information"
      t.string "manager_name"
      t.string "manager_phone_number"
      t.text "new_job_notes"
      t.string "paid_how_often"
      t.integer "paid_yet", default: 0
      t.integer "same_hours", default: 0
      t.string "same_hours_a_week_amount"
      t.string "upper_hours_a_week_amount"
      t.belongs_to(:report, foreign_key: true)
      t.timestamps
    end
  end
end
