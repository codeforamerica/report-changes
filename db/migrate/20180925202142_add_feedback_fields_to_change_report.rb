class AddFeedbackFieldsToChangeReport < ActiveRecord::Migration[5.2]
  def change
    add_column :change_reports, :feedback_rating, :integer
    change_column_default :change_reports, :feedback_rating, from: nil, to: 0

    add_column :change_reports, :feedback_comments, :text
  end
end
