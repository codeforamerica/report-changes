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
end
