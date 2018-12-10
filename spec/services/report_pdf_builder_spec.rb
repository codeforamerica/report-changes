require "rails_helper"

RSpec.describe ReportPdfBuilder do
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
    end
  end
end
