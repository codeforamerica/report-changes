require "rails_helper"

RSpec.describe SelfEmployedForm do
  describe "validations" do
    context "when is_self_employed is provided" do
      it "is valid" do
        form = SelfEmployedForm.new(
          nil,
          is_self_employed: "no",
        )

        expect(form).to be_valid
      end
    end

    context "when is_self_employed is not provided" do
      it "is invalid" do
        form = SelfEmployedForm.new(
          nil,
          is_self_employed: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:is_self_employed]).to be_present
      end
    end
  end

  describe "#save" do
    let(:change_report) { create :change_report }

    let(:valid_params) { { is_self_employed: "no" } }

    it "persists the values to the correct models" do
      form = SelfEmployedForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.is_self_employed_no?).to be_truthy
    end
  end

  describe ".from_change_report" do
    it "assigns values from change report" do
      change_report = create(:change_report, is_self_employed: "no")

      form = SelfEmployedForm.from_change_report(change_report)

      expect(form.is_self_employed).to eq "no"
    end
  end
end
