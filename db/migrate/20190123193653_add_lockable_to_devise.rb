class AddLockableToDevise < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :failed_attempts, :integer, default: 0, null: false
    add_column :admin_users, :locked_at, :datetime
  end
end
