class ChangeReport < ActiveRecord::Base
  has_one :navigator,
          class_name: "ChangeReportNavigator",
          foreign_key: "change_report_id",
          dependent: :destroy

  has_one :member,
           class_name: "HouseholdMember",
           foreign_key: "change_report_id",
           dependent: :destroy

  has_many_attached :letters

  enum change_type: { unfilled: 0, job_termination: 1, new_job: 2, change_in_hours: 3 }, _prefix: :change_type
  enum consent_to_sms: { unfilled: 0, yes: 1, no: 2 }, _prefix: :consented_to_sms
  enum feedback_rating: { unfilled: 0, positive: 1, negative: 2, neutral: 3 }, _prefix: :feedback_rating
  enum paid_yet: { unfilled: 0, yes: 1, no: 2 }, _prefix: :paid_yet
  enum same_hours: { unfilled: 0, yes: 1, no: 2 }, _prefix: :same_hours

  scope :signed, -> { where.not(signature: nil) }

  def has_feedback?
    !feedback_rating_unfilled? || feedback_comments.present?
  end

  def pdf_letters
    letters.select { |letter| letter.content_type == "application/pdf" }
  end

  def image_letters
    letters.select(&:image?)
  end
end
