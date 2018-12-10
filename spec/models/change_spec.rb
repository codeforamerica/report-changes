require "rails_helper"

RSpec.describe Change, type: :model do
  describe "#pdf_documents" do
    it "returns all documents that are content_type application/pdf" do
      change = create :change, report: build(:report)
      change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(change.pdf_documents.count).to eq 1
      expect(change.pdf_documents.first.filename).to eq "document.pdf"
    end
  end

  describe "#image_documents" do
    it "returns all documents that are of image type" do
      change = create :change, report: build(:report)
      change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      change.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )

      expect(change.image_documents.count).to eq 1
      expect(change.image_documents.first.filename).to eq "image.jpg"
    end
  end
end
