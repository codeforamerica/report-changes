class AddHasNewJobDocumentsToNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :navigators, :has_new_job_documents, :integer, default: 0
  end
end
