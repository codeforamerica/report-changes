class RenameHasDocumentsToChangeTypeSpecificFields < ActiveRecord::Migration[5.2]
  def up
    execute <<~SQL
      UPDATE navigators
      SET has_job_termination_documents = (SELECT has_documents FROM navigators WHERE changes.report_id = navigators.report_id AND changes.change_type = 1)
      FROM changes
      WHERE changes.report_id = navigators.report_id AND
      changes.change_type = 1;
    SQL

    execute <<~SQL
      UPDATE navigators
      SET has_new_job_documents = (SELECT has_documents FROM navigators WHERE changes.report_id = navigators.report_id AND changes.change_type = 2)
      FROM changes
      WHERE changes.report_id = navigators.report_id AND
      changes.change_type = 2;
    SQL

    execute <<~SQL
      UPDATE navigators
      SET has_change_in_hours_documents = (SELECT has_documents FROM navigators WHERE changes.report_id = navigators.report_id AND changes.change_type = 3)
      FROM changes
      WHERE changes.report_id = navigators.report_id AND
      changes.change_type = 3;
    SQL

    remove_column :navigators, :has_documents, :integer, default: 0
  end

  def down
    add_column :navigators, :has_documents, :integer, default: 0

    execute <<~SQL
      UPDATE navigators
      SET has_documents = (SELECT has_job_termination_documents FROM navigators WHERE changes.report_id = navigators.report_id AND changes.change_type = 1)
      FROM changes
      WHERE changes.report_id = navigators.report_id AND
      changes.change_type = 1;
    SQL

    execute <<~SQL
      UPDATE navigators
      SET has_documents = (SELECT has_new_job_documents FROM navigators WHERE changes.report_id = navigators.report_id AND changes.change_type = 2)
      FROM changes
      WHERE changes.report_id = navigators.report_id AND
      changes.change_type = 2;
    SQL

    execute <<~SQL
      UPDATE navigators
      SET has_documents = (SELECT has_change_in_hours_documents FROM navigators WHERE changes.report_id = navigators.report_id AND changes.change_type = 3)
      FROM changes
      WHERE changes.report_id = navigators.report_id AND
      changes.change_type = 3;
    SQL
  end
end
