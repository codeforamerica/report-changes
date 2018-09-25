class SuccessForm < Form
  set_attributes_for :change_report, :feedback_rating, :feedback_comments

  validate :feedback_entered

  def feedback_entered
    return true if feedback_rating.present? || feedback_comments.present?
    errors.add(:feedback_rating, "Please select a rating or enter a comment.")
  end

  def save
    change_report.update(attributes_for(:change_report))
  end
end
