require "rails_helper"

RSpec.describe SignSubmitForm do
  describe "validations" do
    context "when signature is provided" do
      it "is valid" do
        form = SignSubmitForm.new(nil, signature: "best person")

        expect(form).to be_valid
      end
    end

    context "when no signature is provided" do
      it "is invalid" do
        form = SignSubmitForm.new(nil, signature: nil)

        expect(form).to_not be_valid
      end
    end
  end

  describe "#save" do
    let(:report) { create :report, :filled }

    let(:valid_params) do
      {
        signature: "Jane Doe",
      }
    end

    it "persists the values to the correct models" do
      form = SignSubmitForm.new(report, valid_params)
      form.valid?
      form.save

      report.reload

      expect(report.signature).to eq "Jane Doe"
      expect(report.submitted_at).to be_within(1.second).of(Time.zone.now)
    end
  end
end
