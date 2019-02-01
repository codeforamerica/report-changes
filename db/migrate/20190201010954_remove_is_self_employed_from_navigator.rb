class RemoveIsSelfEmployedFromNavigator < ActiveRecord::Migration[5.2]
  def change
    remove_column :navigators, :is_self_employed, :integer
    remove_column :navigators, :has_change_in_hours_documents, :integer
    remove_column :navigators, :has_job_termination_documents, :integer
    remove_column :navigators, :has_new_job_documents, :integer
  end
end
