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

      raw_pdf = ReportPdfBuilder.new(ReportDecorator.new(report)).run
      temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
      text_analysis = PDF::Inspector::Text.analyze(temp_file).strings.join.gsub("\n", " ")

      expect(text_analysis).to include("My Signature")
      expect(text_analysis).to include("Person McPeoples")
      expect(text_analysis).to include("Income change: job termination")
      expect(text_analysis).to include("Income change: new job")
      expect(text_analysis).to include("Income change: change in hours/pay")
      expect(text_analysis.scan("This is the test pdf contents").size).to eq 2
    end
  end

  context "job termination" do
    it "creates a pdf from a Change Report" do
      report = ReportDecorator.new(
        create(:report_with_letter,
          :with_change,
          change_type: :job_termination,
          documents: [fixture_file_upload(Rails.root.join("spec", "fixtures", "image.jpg"), "image/jpg")],
          first_name: "Person",
          last_name: "McPeoples"),
      )

      raw_pdf = ReportPdfBuilder.new(report).run
      temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
      text_analysis = PDF::Inspector::Text.analyze(temp_file).strings.join.gsub("\n", " ")

      expect(text_analysis).to include("Person McPeoples")
      expect(text_analysis).to include("Income change: job termination")
      expect(text_analysis).not_to include("Income change: new job")
      expect(text_analysis).not_to include("Income change: change in hours/pay")
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

      raw_pdf = ReportPdfBuilder.new(report).run
      temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
      text_analysis = PDF::Inspector::Text.analyze(temp_file).strings.join.gsub("\n", " ")

      expect(text_analysis).to include("Person McPeoples")
      expect(text_analysis).not_to include("Income change: job termination")
      expect(text_analysis).to include("Income change: new job")
      expect(text_analysis).not_to include("Income change: change in hours/pay")
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

      raw_pdf = ReportPdfBuilder.new(report).run
      temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
      text_analysis = PDF::Inspector::Text.analyze(temp_file).strings.join.gsub("\n", " ")

      expect(text_analysis).to include("Person McPeoples")
      expect(text_analysis).not_to include("Income change: job termination")
      expect(text_analysis).not_to include("Income change: new job")
      expect(text_analysis).to include("Income change: change in hours/pay")
    end
  end

  context "Multiple changes with multiple documents" do
    it "has cover pages for each change type's documents" do
      report = create(:report,
        :with_member,
        navigator: build(:navigator,
          has_job_termination_documents: "yes",
          has_new_job_documents: "yes",
          has_change_in_hours_documents: "yes"))
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

      raw_pdf = ReportPdfBuilder.new(ReportDecorator.new(report)).run
      temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
      text_analysis = PDF::Inspector::Text.analyze(temp_file).strings.join.gsub("\n", " ")

      expect(text_analysis).to include("The following documents are for the reported job termination")
      expect(text_analysis).to include("The following documents are for the reported new job")
      expect(text_analysis).to include("The following documents are for the reported change in hours")
    end
  end
end
