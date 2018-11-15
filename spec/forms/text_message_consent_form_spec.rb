require "rails_helper"

RSpec.describe TextMessageConsentForm do
  describe "#save" do
    let(:change_report) { create :change_report, :with_metadata }

    let(:valid_params) do
      {
        consent_to_sms: "yes",
      }
    end

    it "updates the values to the correct models" do
      form = TextMessageConsentForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.metadata.consent_to_sms).to eq("yes")
    end
  end

  describe ".from_change_report" do
    it "assigns values from change report" do
      change_report = create(:change_report, :with_metadata, consent_to_sms: "no")

      form = TextMessageConsentForm.from_change_report(change_report)

      expect(form.consent_to_sms).to eq("no")
    end
  end
end
