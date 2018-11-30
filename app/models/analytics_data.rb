class AnalyticsData
  def initialize(report)
    @report = report
  end

  def to_h
    hash = report_data.merge(navigator_data).merge(member_data).merge(metadata_data)
    hash.transform_values { |v| unfilled_to_nil(v) }
  end

  private

  attr_reader :report

  def report_data
    {
      change_type: report.change_type,
      days_since_first_day_to_submission: days_since_submission(report.first_day),
      days_since_first_paycheck_to_submission: days_since_submission(report.first_paycheck),
      days_since_last_day_to_submission: days_since_submission(report.last_day),
      days_since_last_paycheck_to_submission: days_since_submission(report.last_paycheck),
      paid_how_often: report.paid_how_often,
      paid_yet: report.paid_yet,
      same_hours: report.same_hours,
      submitted_at: report.submitted_at,
      verification_documents_count: report.letters.count,
    }
  end

  def navigator_data
    navigator = report.navigator
    {
      county_from_address: navigator.try(:county_from_address),
      has_offer_letter: navigator.try(:has_offer_letter),
      has_paystub: navigator.try(:has_paystub),
      has_documents: navigator.try(:has_documents),
      selected_county_location: navigator.try(:selected_county_location),
      is_self_employed: navigator.try(:is_self_employed),
      source: navigator.try(:source),
    }
  end

  def member_data
    member = report.member
    {
      age: member.try(:age),
    }
  end

  def metadata_data
    metadata = report.metadata
    {
      consent_to_sms: metadata.try(:consent_to_sms),
      feedback_rating: metadata.try(:feedback_rating),
    }
  end

  def days_since_submission(date)
    if date && report.submitted_at
      (report.submitted_at - date).to_i / 1.day
    end
  end

  def unfilled_to_nil(value)
    value == "unfilled" ? nil : value
  end
end
