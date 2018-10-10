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

  enum consent_to_sms: { unfilled: 0, yes: 1, no: 2 }, _prefix: :consented_to_sms
  enum feedback_rating: { unfilled: 0, positive: 1, negative: 2, neutral: 3 }, _prefix: :feedback_rating
  enum change_type: { unfilled: 0, job_termination: 1, new_job: 2 },
       _prefix: :change_type

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

  def mixpanel_data
    {
      selected_county_location: navigator.selected_county_location,
      county_from_address: navigator.county_from_address,
      age: member.try(:age),
      has_letter: navigator.has_letter,
      letter_count: letters.count,
      consent_to_sms: consent_to_sms,
      feedback_rating: feedback_rating,
      source: navigator.source,
    }
  end
end
