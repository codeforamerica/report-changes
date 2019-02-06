require "rails_helper"

RSpec.describe TextMessageConsentForm do
  let(:report) { create :report, :filled }

  describe "#save" do
    let(:valid_params) do
      {
        consent_to_sms: "yes",
      }
    end

    it "updates the values to the correct models" do
      form = TextMessageConsentForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.metadata.consent_to_sms).to eq("yes")
    end
  end

  describe ".from_report" do
    it "assigns values from change report" do
      report.metadata.update consent_to_sms: "no"

      form = TextMessageConsentForm.from_report(report)

      expect(form.consent_to_sms).to eq("no")
    end
  end
end
