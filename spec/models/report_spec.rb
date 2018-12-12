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

  describe "#pdf_documents" do
    it "returns all documents for all changes that are content_type application/pdf" do
      report = build(:report)
      create :change,
             report: report,
             documents: [fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf")]
      create :change,
             report: report,
             documents: [fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf")]

      expect(report.pdf_documents.count).to eq 2
      expect(report.pdf_documents.first.filename).to eq "document.pdf"
    end
  end
end
