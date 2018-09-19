require "rails_helper"

RSpec.describe SignSubmitForm do
  describe "validations" do
    context "when signature and signature confirmation are provided" do
      it "is valid" do
        form = SignSubmitForm.new(
          signature: "best person",
          signature_confirmation: "confirmed",
        )

        expect(form).to be_valid
      end
    end

    context "when no signature is provided" do
      it "is invalid" do
        form = SignSubmitForm.new(
          signature: nil,
          signature_confirmation: "confirmed",
        )

        expect(form).to_not be_valid
      end
    end

    context "when signature confirmation is not provided" do
      it "is invalid" do
        form = SignSubmitForm.new(
          signature: "Best Person",
          signature_confirmation: "unfilled",
        )

        expect(form).to_not be_valid
      end
    end
  end

  describe "#save" do
    let(:change_report) { create :change_report }

    let(:valid_params) do
      {
        signature: "Jane Doe",
        signature_confirmation: "confirmed",
        change_report: change_report,
      }
    end

    it "persists the values to the correct models" do
      form = SignSubmitForm.new(valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.signature).to eq "Jane Doe"
      expect(change_report.signature_confirmation).to eq "confirmed"
    end
  end
end
