class AddCaseNumberAndPhoneNumberToChangeReports < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :case_number, :string
    add_column :change_reports, :phone_number, :string
  end
end
