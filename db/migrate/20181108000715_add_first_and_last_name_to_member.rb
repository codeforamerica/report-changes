class AddFirstAndLastNameToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :household_members, :first_name, :string
    add_column :household_members, :last_name, :string

    rename_column :household_members, :name, :full_name_old
  end
end
