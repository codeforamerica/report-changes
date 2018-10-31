class AnalyticsData
  def initialize(change_report)
    @change_report = change_report
  end

  def to_h
    hash = change_report_data.merge(navigator_data).merge(member_data)
    hash.transform_values { |v| unfilled_to_nil(v) }
  end

  private

  attr_reader :change_report

  def change_report_data
    {
      change_type: change_report.change_type,
      consent_to_sms: change_report.consent_to_sms,
      days_since_first_day_to_submission: days_since_submission(change_report.first_day),
      days_since_first_paycheck_to_submission: days_since_submission(change_report.first_paycheck),
      days_since_last_day_to_submission: days_since_submission(change_report.last_day),
      days_since_last_paycheck_to_submission: days_since_submission(change_report.last_paycheck),
      feedback_rating: change_report.feedback_rating,
      is_self_employed: change_report.is_self_employed,
      paid_how_often: change_report.paid_how_often,
      paid_yet: change_report.paid_yet,
      same_hours: change_report.same_hours,
      submitted_at: change_report.submitted_at,
      verification_documents_count: change_report.letters.count,
    }
  end

  def navigator_data
    navigator = change_report.navigator
    {
      county_from_address: navigator.try(:county_from_address),
      has_offer_letter: navigator.try(:has_offer_letter),
      has_paystub: navigator.try(:has_paystub),
      has_termination_letter: navigator.try(:has_termination_letter),
      selected_county_location: navigator.try(:selected_county_location),
      source: navigator.try(:source),
    }
  end

  def member_data
    member = change_report.member
    {
      age: member.try(:age),
    }
  end

  def days_since_submission(date)
    if date && change_report.submitted_at
      (change_report.submitted_at - date).to_i / 1.day
    end
  end

  def unfilled_to_nil(value)
    value == "unfilled" ? nil : value
  end
end
