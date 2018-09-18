require "rails_helper"

RSpec.describe SignSubmitForm do
  describe "validations" do
    context "when signature is provided" do
      it "is valid" do
        form = SignSubmitForm.new(
          signature: "best person",
        )

        expect(form).to be_valid
      end
    end

    context "when no signature is provided" do
      it "is invalid" do
        form = SignSubmitForm.new(
          signature: nil,
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
        change_report: change_report,
      }
    end

    it "persists the values to the correct models" do
      form = SignSubmitForm.new(valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.signature).to eq "Jane Doe"
    end
  end
end
