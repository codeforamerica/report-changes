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

  describe "#unreported_change_types" do
    context "when no changes have been reported" do
      it "returns an array of all the change types" do
        report = build :report, reported_changes: []

        expect(report.unreported_change_types).to eq ["job_termination", "new_job", "change_in_hours"]
      end
    end

    context "when one change has been reported" do
      it "returns an array of available change types" do
        report = create :report
        create :change, change_type: "job_termination", report: report

        expect(report.unreported_change_types).to eq ["new_job", "change_in_hours"]
      end
    end

    context "when all changes have been reported" do
      it "returns an empty array" do
        report = create :report
        create :change, change_type: :job_termination, report: report
        create :change, change_type: :new_job, report: report
        create :change, change_type: :change_in_hours, report: report

        expect(report.unreported_change_types).to eq []
      end
    end
  end
end
