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

  has_one :job_termination_change,
          -> { where(change_type: "job_termination").limit(1) },
          class_name: "Change"

  has_one :new_job_change,
          -> { where(change_type: "new_job").limit(1) },
          class_name: "Change"

  has_one :change_in_hours_change,
          -> { where(change_type: "change_in_hours").limit(1) },
          class_name: "Change"

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
end
