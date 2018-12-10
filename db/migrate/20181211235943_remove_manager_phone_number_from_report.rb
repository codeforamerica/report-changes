class RemoveManagerPhoneNumberFromReport < ActiveRecord::Migration[5.2]
  def change
    remove_column :reports, :manager_phone_number
  end
end
