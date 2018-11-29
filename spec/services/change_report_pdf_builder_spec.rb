require "rails_helper"

RSpec.describe ChangeReportPdfBuilder do
  context "job termination" do
    it "creates a pdf from a Change Report" do
      change_report = create :change_report_with_letter, :job_termination
      change_report.member.update first_name: "Person", last_name: "McPeoples"

      decorated_change_report = ChangeReportDecorator.new change_report

      raw_pdf = ChangeReportPdfBuilder.new(decorated_change_report).run
      temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
      text_analysis = PDF::Inspector::Text.analyze(temp_file).strings.join.gsub("\n", " ")

      expect(text_analysis).to include("Person McPeoples")
      expect(text_analysis).to include("job termination")
    end
  end

  context "new job" do
    it "creates a pdf from a Change Report" do
      change_report = create :change_report_with_letter, :new_job
      change_report.member.update first_name: "Person", last_name: "McPeoples"

      decorated_change_report = ChangeReportDecorator.new change_report

      raw_pdf = ChangeReportPdfBuilder.new(decorated_change_report).run
      temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
      text_analysis = PDF::Inspector::Text.analyze(temp_file).strings.join.gsub("\n", " ")

      expect(text_analysis).to include("Person McPeoples")
      expect(text_analysis).to include("new job")
    end
  end
end
