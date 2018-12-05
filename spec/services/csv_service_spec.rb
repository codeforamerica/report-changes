require "rails_helper"

RSpec.describe CsvService do
  it "creates a csv with a header from the active record collection" do
    3.times do
      create :report
    end
    create :report, :with_member, case_number: "1a12345", reported_change: build(:change, change_type: :new_job)

    reports = Report.all.map { |report| ReportDecorator.new(report) }
    csv = CsvService.new(
      active_record_collection: reports,
      header_attributes: ReportDecorator.header_attributes,
    ).run
    parsed_csv = CSV.parse(csv)

    expect(parsed_csv.count).to eq 5
    expect(parsed_csv.first).to include "case_number"
    expect(parsed_csv.first).to include "birthday"
    expect(parsed_csv.first).to include "change_type_description"
    expect(parsed_csv.last).to include "1a12345"
    expect(parsed_csv.last).to include "Quincy Jones"
    expect(parsed_csv.last).to include "Income change: new job"
  end
end
