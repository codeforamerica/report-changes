require "rails_helper"

RSpec.describe TextMessageConsentForm do
  describe "#save" do
    let(:change_report) { create :change_report }

    let(:valid_params) do
      {
        consent_to_sms: "yes",
      }
    end

    it "persists the values to the correct models" do
      form = TextMessageConsentForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.consent_to_sms).to eq("yes")
    end
  end
end
