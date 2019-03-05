require "rails_helper"

RSpec.describe CsvService do
  it "creates a csv with a header from the active record collection" do
    report = create :report, :filled, signature: "X"
    report.members.first.update(
      first_name: "Quincy",
      last_name: "Jones",
      case_number: "1a12345",
    )
    report.members.first.reported_changes.first.update(change_type: "job_termination")
    create(:member,
      first_name: "Frank",
      last_name: "Sinatra",
      case_number: "fake_case_number",
      report: report)
    create(:change,
      change_type: :new_job,
      member: report.members.second)

    csv = CsvService.run
    parsed_csv = CSV.parse(csv)

    expect(parsed_csv.count).to eq 3

    expect(parsed_csv.first).to include "report_id"

    expect(parsed_csv.second).to include "Quincy Jones"
    expect(parsed_csv.second).to include "1a12345"
    expect(parsed_csv.second).to include "job_termination"

    expect(parsed_csv.third).to include "Frank Sinatra"
    expect(parsed_csv.third).to include "fake_case_number"
    expect(parsed_csv.third).to include "new_job"
  end
end
