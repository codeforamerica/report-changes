require "rails_helper"

RSpec.describe ReportPdfBuilder do
  context "multiple changes" do
    it "creates a Report pdf from multiple changes" do
      report = create(:report_with_letter,
                      first_name: "Person",
                      last_name: "McPeoples",
                      signature: "My Signature")

      create(:change,
        report: report,
        change_type: :job_termination,
        documents: [
          fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpeg"),
        ])
      create(:change,
        report: report,
        change_type: :new_job,
        documents: [
          fixture_file_upload(Rails.root.join("spec", "fixtures", "document.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "fixtures", "image2.jpg"), "image/jpeg"),
        ])
      create(:change,
        report: report,
        change_type: :change_in_hours)

      pdf = ReportPdfBuilder.new(ReportDecorator.new(report)).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).to include("My Signature")
      expect(pdf_text).to include("Person McPeoples")
      expect(pdf_text).to include("Income change: job termination")
      expect(pdf_text).to include("Income change: new job")
      expect(pdf_text).to include("Income change: change in hours/pay")
      expect(pdf_text.scan("This is the test pdf contents").size).to eq 2
    end
  end

  context "job termination" do
    let(:report) do
      ReportDecorator.new(
        create(:report_with_letter,
          :with_change,
          change_type: :job_termination,
          first_name: "Person",
          last_name: "McPeoples"),
      )
    end

    it "creates a pdf from a Change Report" do
      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).to include("Person McPeoples")
      expect(pdf_text).to include("Income change: job termination")
      expect(pdf_text).not_to include("Income change: new job")
      expect(pdf_text).not_to include("Income change: change in hours/pay")
    end

    it "does't create a doc cover sheet when no documents are uploaded." do
      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).not_to include("Job termination verification documents")
    end
  end

  context "new job" do
    it "creates a pdf from a Change Report" do
      report = ReportDecorator.new(
        create(:report_with_letter,
               :with_change,
               change_type: :new_job,
               documents: [fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")],
               first_name: "Person",
               last_name: "McPeoples"),
      )

      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).to include("Person McPeoples")
      expect(pdf_text).not_to include("Income change: job termination")
      expect(pdf_text).to include("Income change: new job")
      expect(pdf_text).not_to include("Income change: change in hours/pay")
    end
  end

  context "change in hours" do
    it "creates a pdf from a Change Report" do
      report = ReportDecorator.new(
        create(:report_with_letter,
               :with_change,
               change_type: :change_in_hours,
               documents: [fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")],
               first_name: "Person",
               last_name: "McPeoples"),
      )

      pdf = ReportPdfBuilder.new(report).run
      pdf_text = pdf_to_text(pdf)

      expect(pdf_text).to include("Person McPeoples")
      expect(pdf_text).not_to include("Income change: job termination")
      expect(pdf_text).not_to include("Income change: new job")
      expect(pdf_text).to include("Income change: change in hours/pay")
    end
  end

  context "Multiple changes with multiple documents" do
    it "has cover pages for each change type's documents" do
      report = create :report, :with_member, :with_navigator
      termination = create(:change, change_type: "job_termination", report: report)
      termination.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )
      termination.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      new_job = create(:change, change_type: "new_job", report: report)
      new_job.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )
      new_job.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )
      change_in_hours = create(:change, change_type: "change_in_hours", report: report)
      change_in_hours.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "document.pdf")),
        filename: "document.pdf",
        content_type: "application/pdf",
      )
      change_in_hours.documents.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "image.jpg")),
        filename: "image.jpg",
        content_type: "image/jpg",
      )

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
