class CreateChangeReport < ActiveRecord::Migration[5.2]
  def change
    create_table :change_reports, &:timestamps
  end
end
