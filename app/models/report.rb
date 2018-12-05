class Report < ActiveRecord::Base
  has_one :navigator,
          class_name: "Navigator",
          foreign_key: "change_report_id",
          dependent: :destroy

  has_one :metadata,
          class_name: "ReportMetadata",
          foreign_key: "change_report_id",
          dependent: :destroy

  has_one :member,
          class_name: "HouseholdMember",
          foreign_key: "change_report_id",
          dependent: :destroy

  has_one :reported_change,
           class_name: "Change",
           foreign_key: "report_id",
           dependent: :destroy

  has_many_attached :letters

  scope :signed, -> { where.not(signature: nil) }

  def pdf_letters
    letters.select { |letter| letter.content_type == "application/pdf" }
  end

  def image_letters
    letters.select(&:image?)
  end
end
