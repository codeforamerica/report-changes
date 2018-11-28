class ChangeReport < ActiveRecord::Base
  belongs_to :member, class_name: "HouseholdMember", foreign_key: :household_member_id
  belongs_to :navigator

  has_one :metadata,
          class_name: "ChangeReportMetadata",
          foreign_key: "change_report_id",
          dependent: :destroy

  has_many_attached :letters

  enum change_type: { unfilled: 0, job_termination: 1, new_job: 2, change_in_hours: 3 }, _prefix: :change_type
  enum has_documents: { unfilled: 0, yes: 1, no: 2 }, _prefix: :has_documents
  enum paid_yet: { unfilled: 0, yes: 1, no: 2 }, _prefix: :paid_yet
  enum same_hours: { unfilled: 0, yes: 1, no: 2 }, _prefix: :same_hours

  scope :signed, -> { where.not(signature: nil) }

  def pdf_letters
    letters.select { |letter| letter.content_type == "application/pdf" }
  end

  def image_letters
    letters.select(&:image?)
  end
end
