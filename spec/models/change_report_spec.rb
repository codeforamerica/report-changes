require "rails_helper"

RSpec.describe ChangeReport, type: :model do
  describe ".signed" do
    it "only returns signed change reports" do
      signed_change_report = create :change_report, signature: "Quincy Jones"
      second_signed_change_report = create :change_report, signature: "Frank Sinatra"
      _unsigned_change_report = create :change_report

      expect(ChangeReport.signed).to eq [signed_change_report, second_signed_change_report]
    end
  end

  describe "#pdf_letters" do
    it "returns all letters that are content_type application/pdf" do
      change_report = create :change_report
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(change_report.pdf_letters.count).to eq 1
      expect(change_report.pdf_letters.first.filename).to eq "document.pdf"
    end
  end

  describe "#image_letters" do
    it "returns all letters that are of image type" do
      change_report = create :change_report
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      change_report.letters.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(change_report.image_letters.count).to eq 1
      expect(change_report.image_letters.first.filename).to eq "image.jpg"
    end
  end
end
