class CreateHouseholdMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :household_members do |t|
      t.references :change_report
      t.string :name
      t.string :encrypted_ssn
      t.string :encrypted_ssn_iv
      t.datetime :birthday
      t.timestamps
    end
  end
end
