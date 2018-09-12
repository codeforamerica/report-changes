class CreateChangeReport < ActiveRecord::Migration[5.2]
  def change
    create_table :change_reports do |t|
      t.timestamps
    end
  end
end
