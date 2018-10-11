require "rails_helper"

RSpec.describe ApplicationMailer do
  describe ".office_change_report_submission" do
    it "sets the correct headers" do
      with_modified_env HOSTNAME_FOR_URLS: "example.com" do
        email = ApplicationMailer.office_change_report_submission(
          pdf: "my pdf",
          client_name: "Joe MacMillan",
        )
        from_header = email.header.select do |header|
          header.name == "From"
        end.first.value

        expect(from_header).to eq %("ReportChangesColorado" <hello@example.com>)
        expect(email.from).to eq(["hello@example.com"])
        expect(email.subject).to eq("A new change report from Joe MacMillan was submitted!")
      end
    end

    it "sets recipient based on credentials" do
      email = ApplicationMailer.office_change_report_submission(
        pdf: "my pdf",
        client_name: "Joe MacMillan",
      )

      expect(email.to).to eq(["county@example.com"])
    end

    it "attaches the application PDF with correct name" do
      time = Time.utc(1999, 1, 1, 10, 5, 0)
      Timecop.freeze(time) do
        email = ApplicationMailer.office_change_report_submission(
          pdf: "my pdf",
          client_name: "Joe MacMillan",
        )

        expect(email.attachments.count).to eq(1)
        expect(email.attachments.first.filename).to eq("1999-01-01_Joe_MacMillan_Change_Report.pdf")
      end
    end
  end
end
