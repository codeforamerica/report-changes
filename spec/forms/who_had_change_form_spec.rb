require "rails_helper"

RSpec.describe WhoHadChangeForm do
  describe "validations" do
    context "when submitting_for is provided" do
      it "is valid" do
        form = WhoHadChangeForm.new(
          nil,
          submitting_for: "self",
        )

        expect(form).to be_valid
      end
    end

    context "when submitting_for is not provided" do
      it "is invalid" do
        form = WhoHadChangeForm.new(
          nil,
          submitting_for: nil,
        )

        expect(form).not_to be_valid
        expect(form.errors[:submitting_for]).to be_present
      end
    end
  end

  describe "#save" do
    let(:valid_params) do
      {
        submitting_for: "self",
      }
    end

    it "persists the values to the correct models" do
      change_report = create(:change_report, :with_navigator)
      form = WhoHadChangeForm.new(change_report, valid_params)
      form.valid?
      form.save

      change_report.reload

      expect(change_report.navigator.submitting_for).to eq("self")
    end
  end

  describe ".from_change_report" do
    it "assigns values from change report" do
      navigator = build(:change_report_navigator, submitting_for: "self")
      change_report = create(:change_report, navigator: navigator)

      form = WhoHadChangeForm.from_change_report(change_report)

      expect(form.submitting_for).to eq("self")
    end
  end
end
