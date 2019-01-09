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

  describe "#name" do
    context "job_termination" do
      it "has a name of job termination" do
        change = create :change, change_type: :job_termination, report: build(:report)
        expect(change.name).to eq "job termination"
      end
    end

    context "new_job" do
      it "has a name of new_job" do
        change = create :change, change_type: :new_job, report: build(:report)
        expect(change.name).to eq "new job"
      end
    end

    context "change_in_hours" do
      it "has a name of change in hours/pay" do
        change = create :change, change_type: :change_in_hours, report: build(:report)
        expect(change.name).to eq "change in hours/pay"
      end
    end
  end
end
