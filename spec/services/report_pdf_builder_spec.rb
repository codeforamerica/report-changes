require "rails_helper"

RSpec.describe ReportPdfBuilder do
  context "multiple changes" do
    it "creates a Report pdf from multiple changes" do
      report = create :report, :filled, signature: "My Signature"
      report.current_member.update first_name: "Person", last_name: "McPeoples"
      create(:change,
        change_type: :new_job,
        member: report.current_member,
        documents: [
          fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpeg"),
        ])
      create(:change,
        change_type: :change_in_hours,
        member: report.current_member,
        documents: [
          fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "fixtures", "image2.jpg"), "image/jpeg"),
        ])

      pdf = ReportPdfBuilder.new(ReportDecorator.new(report)).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).to include("My Signature")
      expect(pdf_text).to include("Person McPeoples")
      expect(pdf_text).to include("Income change: job termination")
      expect(pdf_text).to include("Income change: new job")
      expect(pdf_text).to include("Income change: change in hours/pay")
      expect(pdf_text.scan("This is the test pdf contents").size).to eq 2
      expect(pdf_text).to include("9 / 9")
    end
  end

  context "job termination" do
    it "creates a pdf from a Change Report" do
      report = create :report, :filled, signature: "My Signature"
      report.current_member.update first_name: "Person", last_name: "McPeoples"

      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).to include("Person McPeoples")
      expect(pdf_text).to include("Income change: job termination")
      expect(pdf_text).not_to include("Income change: new job")
      expect(pdf_text).not_to include("Income change: change in hours/pay")
    end

    it "does't create a doc cover sheet when no documents are uploaded." do
      report = create :report, :filled

      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).not_to include("Job termination verification documents")
    end
  end

  context "new job" do
    it "creates a pdf from a Change Report" do
      report = create :report, :filled, change_type: "new_job"

      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).not_to include("Income change: job termination")
      expect(pdf_text).to include("Income change: new job")
      expect(pdf_text).not_to include("Income change: change in hours/pay")
    end
  end

  context "change in hours" do
    it "creates a pdf from a Change Report" do
      report = create :report, :filled, change_type: "change_in_hours"

      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).not_to include("Income change: job termination")
      expect(pdf_text).not_to include("Income change: new job")
      expect(pdf_text).to include("Income change: change in hours/pay")
    end
  end

  context "Multiple changes with multiple documents" do
    it "has cover pages for each change type's documents" do
      report = create :report, :filled, signature: "My Signature"
      report.current_member.update first_name: "Person", last_name: "McPeoples"
      create(:change,
        change_type: :new_job,
        member: report.current_member,
        documents: [
          fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpeg"),
        ])
      create(:change,
        change_type: :change_in_hours,
        member: report.current_member,
        documents: [
          fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "fixtures", "image2.jpg"), "image/jpeg"),
        ])
      report.current_change.documents = [
        fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
        fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpeg"),
      ]

      expect(report.pdf_documents.count).to eq 3
      expect(report.image_documents.count).to eq 3

      pdf = ReportPdfBuilder.new(ReportDecorator.new(report)).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).to include("Job termination verification documents")
      expect(pdf_text).to include("New job verification documents")
      expect(pdf_text).to include("Change in hours/pay verification documents")
      expect(pdf_text).to include("2 documents")
    end
  end
end
