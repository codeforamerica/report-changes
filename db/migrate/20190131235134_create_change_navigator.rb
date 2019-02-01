class CreateChangeNavigator < ActiveRecord::Migration[5.2]
  def change
    create_table :change_navigators do |t|
      t.integer :is_self_employed, default: 0
      t.integer :has_documents, default: 0
      t.belongs_to :change, foreign_key: true
    end
  end
end
