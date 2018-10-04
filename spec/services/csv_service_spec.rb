require "rails_helper"

RSpec.describe CsvService do
  it "creates a csv with a header from the active record collection" do
    3.times do
      create :change_report
    end
    create :change_report, :with_member, case_number: "1a12345"

    change_reports = ChangeReport.all.map { |change_report| ChangeReportDecorator.new(change_report) }
    csv = CsvService.new(
      active_record_collection: change_reports,
      header_attributes: ChangeReportDecorator.header_attributes,
    ).run
    parsed_csv = CSV.parse(csv)

    expect(parsed_csv.count).to eq 5
    expect(parsed_csv.first).to include "case_number"
    expect(parsed_csv.first).to include "birthday"
    expect(parsed_csv.last).to include "1a12345"
    expect(parsed_csv.last).to include "Frank Sinatra"
  end
end
