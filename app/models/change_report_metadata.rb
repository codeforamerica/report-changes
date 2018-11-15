class ChangeReportMetadata < ActiveRecord::Base
  belongs_to :change_report

  enum consent_to_sms: { unfilled: 0, yes: 1, no: 2 }, _prefix: :consented_to_sms
  enum feedback_rating: { unfilled: 0, positive: 1, negative: 2, neutral: 3 }, _prefix: :feedback_rating

  def has_feedback?
    !feedback_rating_unfilled? || feedback_comments.present?
  end
end
