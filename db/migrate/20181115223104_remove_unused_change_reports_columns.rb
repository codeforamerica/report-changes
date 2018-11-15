class RemoveUnusedChangeReportsColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :change_reports, :consent_to_sms
    remove_column :change_reports, :feedback_rating
    remove_column :change_reports, :feedback_comments
    remove_column :change_reports, :submitting_for
    remove_column :change_reports, :is_self_employed
  end
end
