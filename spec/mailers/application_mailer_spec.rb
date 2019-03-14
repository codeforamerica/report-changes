require "rails_helper"

RSpec.describe ApplicationMailer do
  let(:report) do
    create :report, :filled,
      signature: "Joe MacMillan",
      metadata: build(:report_metadata, email: "fake@example.com")
  end

  describe ".office_change_report_submission" do
    it "sets the correct headers" do
      with_modified_env SENDING_EMAIL_ADDRESS: "hello@example.com" do
        email = ApplicationMailer.office_change_report_submission(report)

        from_header = email.header.select do |header|
          header.name == "From"
        end.first.value

        expect(from_header).to eq %("ReportChangesColorado" <hello@example.com>)
        expect(email.from).to eq(["hello@example.com"])
        expect(email.subject).to eq("A new change report from Joe MacMillan was submitted!")
      end
    end

    context "araphaoe" do
      it "sets recipient email from credentials" do
        report.navigator.update(county: "Arapahoe")

        email = ApplicationMailer.office_change_report_submission(report)

        expect(email.to).to eq(["arapahoe@example.com"])
      end
    end

    context "pitkin" do
      it "sets recipient email from credentials" do
        report.navigator.update(county: "Pitkin")

        email = ApplicationMailer.office_change_report_submission(report)

        expect(email.to).to eq(["pitkin@example.com"])
      end
    end

    it "attaches the change report PDF with correct name" do
      time = Time.utc(1999, 1, 1, 10, 5, 0)
      Timecop.freeze(time) do
        pdf = "pdf contents"
        builder = instance_double(ReportPdfBuilder, run: pdf)
        allow(ReportPdfBuilder).to receive(:new).with(an_instance_of(ReportDecorator)).and_return(builder)
        email = ApplicationMailer.office_change_report_submission(report)

        expect(email.attachments.count).to eq(1)
        expect(email.attachments.first.read).to eq(pdf)
        expect(email.attachments.first.filename).to eq("1999-01-01_Joe_MacMillan_Change_Report.pdf")
      end
    end
  end

  describe ".report_copy_to_client" do
    it "sets the correct headers" do
      with_modified_env SENDING_EMAIL_ADDRESS: "hello@example.com" do
        email = ApplicationMailer.report_copy_to_client(report)

        from_header = email.header.select do |header|
          header.name == "From"
        end.first.value

        expect(from_header).to eq %("ReportChangesColorado" <hello@example.com>)
        expect(email.from).to eq(["hello@example.com"])
        expect(email.subject).to eq("The requested copy of your change report.")
      end
    end

    it "sets recipient email from credentials" do
      email = ApplicationMailer.report_copy_to_client(report)

      expect(email.to).to eq(["fake@example.com"])
    end
  end
end
