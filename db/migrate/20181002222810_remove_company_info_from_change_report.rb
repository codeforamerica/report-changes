class RemoveCompanyInfoFromChangeReport < ActiveRecord::Migration[5.2]
  def change
    remove_column :change_reports, :company_address, :string
    remove_column :change_reports, :company_phone_number, :string
  end
end
