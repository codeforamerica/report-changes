class Report < ActiveRecord::Base
  has_one :navigator, dependent: :destroy

  has_one :metadata,
          class_name: "ReportMetadata",
          dependent: :destroy

  has_many :members, dependent: :destroy

  has_many :reported_changes,
          class_name: "Change",
          through: :members

  scope :signed, -> { where.not(signature: nil) }

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

  def current_change
    navigator&.current_change
  end

  def current_member
    navigator&.current_member
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

  def submitter
    members.where(is_submitter: true).first
  end

  def member_names
    members.map(&:full_name).join(", ")
  end
end
