class AddHasChangeInHoursDocumentsToNavigator < ActiveRecord::Migration[5.2]
  def change
    add_column :navigators, :has_change_in_hours_documents, :integer, default: 0
  end
end
