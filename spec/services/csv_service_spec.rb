require "rails_helper"

RSpec.describe CsvService do
  it "creates a csv with a header from the active record collection" do
    3.times do
      create :report
    end
    report = create :report, :with_member, case_number: "1a12345"
    create(:change, :job_termination, report: report)
    create(:change, :new_job, report: report)
    create(:change, :change_in_hours, report: report)

    reports = Report.all.map { |r| ReportDecorator.new(r) }
    csv = CsvService.new(
      active_record_collection: reports,
      header_attributes: ReportDecorator.header_attributes,
    ).run
    parsed_csv = CSV.parse(csv)

    expect(parsed_csv.count).to eq 5
    expect(parsed_csv.first).to include "case_number"
    expect(parsed_csv.first).to include "birthday"
    expect(parsed_csv.last).to include "1a12345"
    expect(parsed_csv.last).to include "Quincy Jones"
  end
end
