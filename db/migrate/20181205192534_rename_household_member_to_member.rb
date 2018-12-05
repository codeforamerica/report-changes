class RenameHouseholdMemberToMember < ActiveRecord::Migration[5.2]
  def change
    rename_table :household_members, :members
  end
end
