require "rails_helper"

RSpec.describe Report, type: :model do
  describe ".signed" do
    it "only returns signed change reports" do
      signed_report = create :report, signature: "Quincy Jones"
      second_signed_report = create :report, signature: "Frank Sinatra"
      _unsigned_report = create :report

      expect(Report.signed).to eq [signed_report, second_signed_report]
    end
  end

  describe "#pdf_letters" do
    it "returns all letters that are content_type application/pdf" do
      report = create :report
      report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(report.pdf_letters.count).to eq 1
      expect(report.pdf_letters.first.filename).to eq "document.pdf"
    end
  end

  describe "#image_letters" do
    it "returns all letters that are of image type" do
      report = create :report
      report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(report.image_letters.count).to eq 1
      expect(report.image_letters.first.filename).to eq "image.jpg"
    end
  end
end
