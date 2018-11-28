class NavigatorsHaveMembers < ActiveRecord::Migration[5.2]
  def change
    add_reference :change_reports, :navigator, index: true
    add_reference :household_members, :navigator, index: true
  end
end
