require "rails_helper"

RSpec.describe ChangeReportPdfBuilder do
  it "creates a pdf from a Change Report" do
    change_report = create(:change_report_with_letter, name: "Person McPeoples")

    raw_pdf = ChangeReportPdfBuilder.new(change_report).run
    temp_file = write_raw_pdf_to_temp_file(source: raw_pdf)
    text_analysis = PDF::Inspector::Text.analyze(temp_file)

    expect(text_analysis.strings.join).to include("Person McPeoples")
  end
end
