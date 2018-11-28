class MoveHasDocumentsToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :has_documents, :integer, default: 0
  end
end
