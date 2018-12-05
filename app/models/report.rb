class Report < ActiveRecord::Base
  has_one :navigator, dependent: :destroy
  has_one :member, dependent: :destroy

  has_one :metadata,
          class_name: "ReportMetadata",
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
