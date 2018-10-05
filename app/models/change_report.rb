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

  enum signature_confirmation: { unfilled: 0, yes: 1 }, _prefix: :confirmed_signature
  enum consent_to_sms: { unfilled: 0, yes: 1, no: 2 }, _prefix: :consented_to_sms
  enum feedback_rating: { unfilled: 0, positive: 1, negative: 2, neutral: 3 }, _prefix: :feedback_rating

  scope :signed, -> { where(signature_confirmation: "yes").where.not(signature: nil) }

  def has_feedback?
    !feedback_rating_unfilled? || feedback_comments.present?
  end

  def pdf_letters
    letters.select { |letter| letter.content_type == "application/pdf" }
  end

  def mixpanel_data
    {
      selected_county_location: navigator.selected_county_location,
      county_from_address: navigator.county_from_address,
      age: member.try(:age),
      has_letter: navigator.has_letter,
      letter_count: letters.count,
      consent_to_sms: consent_to_sms,
      signature_confirmation: signature_confirmation,
      feedback_rating: feedback_rating,
    }
  end
end
