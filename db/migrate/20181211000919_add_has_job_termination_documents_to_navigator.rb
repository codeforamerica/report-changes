class AddHasJobTerminationDocumentsToNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :navigators, :has_job_termination_documents, :integer, default: 0
  end
end
