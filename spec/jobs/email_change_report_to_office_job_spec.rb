require "rails_helper"

RSpec.describe EmailChangeReportToOfficeJob do
  describe "#perform" do
    it "should enqueue an email to be sent" do
      change_report = create(:change_report, :with_member, first_name: "Princess", last_name: "Caroline")

      fake_pdf = double("pdf")
      fake_builder = instance_double(ChangeReportPdfBuilder)
      fake_mailer = double("mail").as_null_object

      allow(ChangeReportPdfBuilder).to receive(:new).with(change_report) { fake_builder }
      allow(fake_builder).to receive(:run) { fake_pdf }

      expect(ApplicationMailer).to receive(:office_change_report_submission).with(
        pdf: fake_pdf,
        client_name: "Princess Caroline",
      ) { fake_mailer }
      expect(fake_mailer).to receive(:deliver)

      EmailChangeReportToOfficeJob.perform_now(change_report: change_report)
    end
  end
end
