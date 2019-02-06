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
      report = create :report, :filled
      report.current_change.documents = [
        fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
        fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
      ]

      expect(report.pdf_documents.count).to eq 2
      expect(report.pdf_documents.first.filename).to eq "document.pdf"
    end
  end

  describe "#submitter" do
    it "returns the reports submitter" do
      report = create :report
      submitter = create :member, is_submitter: true, report: report
      create :member, is_submitter: false, report: report
      create :member, is_submitter: false, report: report

      expect(report.submitter).to eq submitter
    end
  end

  describe "#member_names" do
    it "returns all of the members names" do
      report = create :report, :filled
      report.current_member.update first_name: "Frank", last_name: "Sinatra"
      create :member, first_name: "Quincy", last_name: "Jones", report: report

      expect(report.member_names).to eq "Frank Sinatra, Quincy Jones"
    end
  end
end
