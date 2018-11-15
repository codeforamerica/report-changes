class SuccessForm < Form
  set_attributes_for :metadata, :feedback_rating, :feedback_comments

  validate :feedback_entered

  def feedback_entered
    return true if feedback_rating.present? || feedback_comments.present?

    errors.add(:feedback_rating, "Please select a rating or enter a comment.")
  end

  def save
    change_report.metadata.update(attributes_for(:metadata))
  end
end
