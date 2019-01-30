class Change < ApplicationRecord
  belongs_to :report

  has_many_attached :documents

  enum change_type: { unfilled: 0, job_termination: 1, new_job: 2, change_in_hours: 3 }, _prefix: :change_type
  enum paid_yet: { unfilled: 0, yes: 1, no: 2 }, _prefix: :paid_yet
  enum same_hours: { unfilled: 0, yes: 1, no: 2 }, _prefix: :same_hours

  def pdf_documents
    documents.select { |document| document.content_type == "application/pdf" }
  end

  def image_documents
    documents.select(&:image?)
  end

  def name
    case change_type
    when "job_termination"
      "job termination"
    when "new_job"
      "new job"
    when "change_in_hours"
      "change in hours/pay"
    end
  end

  def show?
    case change_type
    when "job_termination"
      report.navigator.has_job_termination_documents_unfilled?
    when "new_job"
      report.navigator.has_new_job_documents_unfilled?
    when "change_in_hours"
      report.navigator.has_change_in_hours_documents_unfilled?
    end
  end

  def new_job_hours_a_week
    if same_hours_yes?
      same_hours_a_week_amount
    elsif same_hours_no?
      "#{lower_hours_a_week_amount} - #{upper_hours_a_week_amount}"
    end
  end

  def change_in_hours_hours_a_week
    if upper_hours_a_week_amount.present?
      "#{lower_hours_a_week_amount} - #{upper_hours_a_week_amount}"
    else
      lower_hours_a_week_amount
    end
  end
end
