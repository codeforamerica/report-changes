class AnalyticsData
  def initialize(report)
    @report = report
  end

  def to_h
    hash = report_data.merge(navigator_data).merge(member_data).merge(metadata_data).merge(change_counts)
    hash.transform_values { |v| unfilled_to_nil(v) }
  end

  private

  attr_reader :report

  def report_data
    {
      submitted_at: report.submitted_at,
      time_to_complete: time_to_complete,
      verification_documents_count: report.document_count,
    }
  end

  def change_counts
    {
      job_termination_count: report.reported_changes.where(change_type: "job_termination").count,
      new_job_count: report.reported_changes.where(change_type: "new_job").count,
      change_in_hours_count: report.reported_changes.where(change_type: "change_in_hours").count,
    }
  end

  def navigator_data
    navigator = report.navigator
    {
      county_from_address: navigator.try(:county_from_address),
      selected_county_location: navigator.try(:selected_county_location),
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
      feedback_comments: metadata.try(:feedback_comments),
      what_county: metadata.try(:what_county),
      want_a_copy: metadata.try(:email).present?,
    }
  end

  def unfilled_to_nil(value)
    value == "unfilled" ? nil : value
  end

  def time_to_complete
    (report.submitted_at - report.created_at) / 1.second if report.submitted_at
  end
end
