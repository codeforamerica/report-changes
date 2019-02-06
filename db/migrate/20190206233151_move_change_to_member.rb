class MoveChangeToMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :changes, :member, index: true
    add_column :members, :is_submitter, :boolean
    add_column :members, :phone_number, :string
    add_column :members, :case_number, :string

    add_column :navigators, :temp_change_type, :integer, default: 0
    add_column :navigators, :current_member_id, :integer
    add_column :navigators, :current_change_id, :integer
  end
end
