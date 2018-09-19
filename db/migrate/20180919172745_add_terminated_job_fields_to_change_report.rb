class AddTerminatedJobFieldsToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :company_name, :string
    add_column :change_reports, :company_address, :string
    add_column :change_reports, :company_phone_number, :string
    add_column :change_reports, :last_day, :datetime
    add_column :change_reports, :last_paycheck, :datetime
  end
end
