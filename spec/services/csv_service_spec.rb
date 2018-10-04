require "rails_helper"

RSpec.describe CsvService do
  it "creates a csv with a header from the active record collection" do
    3.times do
      create :change_report
    end
    create :change_report, :with_member, case_number: "1a12345"

    csv = CsvService.new(ChangeReport.all).run
    parsed_csv = CSV.parse(csv)

    expect(parsed_csv.count).to eq 5
    expect(parsed_csv.first).to include "id"
    expect(parsed_csv.first).to include "birthday"
    expect(parsed_csv.last).to include "1a12345"
    expect(parsed_csv.last).to include "Frank Sinatra"
  end
end