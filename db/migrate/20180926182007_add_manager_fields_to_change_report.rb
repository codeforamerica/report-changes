class AddManagerFieldsToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :manager_name, :string
    add_column :change_reports, :manager_phone_number, :string
    add_column :change_reports, :manager_additional_information, :string
  end
end
