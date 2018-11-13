class RemoveFullNameFromMember < ActiveRecord::Migration[5.2]
  def change
    remove_column :household_members, :full_name_old
  end
end
