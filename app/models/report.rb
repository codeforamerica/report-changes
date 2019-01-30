class Report < ActiveRecord::Base
  has_one :navigator, dependent: :destroy
  has_one :member, dependent: :destroy

  has_one :metadata,
          class_name: "ReportMetadata",
          dependent: :destroy

  has_many :reported_changes,
          class_name: "Change",
          foreign_key: "report_id",
          dependent: :destroy

  scope :signed, -> { where.not(signature: nil) }

  has_many_attached :letters

  def pdf_documents
    reported_changes.map(&:pdf_documents).flatten
  end

  def image_documents
    reported_changes.map(&:image_documents).flatten
  end

  def document_count
    (reported_changes.map(&:pdf_documents).flatten + reported_changes.map(&:image_documents).flatten).count
  end

  def unreported_change_types
    all_change_types = Change.change_types.keys - ["unfilled"]
    reported_change_types = reported_changes.pluck :change_type
    all_change_types - reported_change_types
  end

  def has_job_termination_change?
    reported_changes.any? { |change| change.change_type == "job_termination" }
  end

  def has_new_job_change?
    reported_changes.any? { |change| change.change_type == "new_job" }
  end

  def has_change_in_hours_change?
    reported_changes.any? { |change| change.change_type == "change_in_hours" }
  end

  def first_job_termination_change
    reported_changes.where(change_type: "job_termination").first
  end

  def first_new_job_change
    reported_changes.where(change_type: "new_job").first
  end

  def first_change_in_hours_change
    reported_changes.where(change_type: "change_in_hours").first
  end
end
