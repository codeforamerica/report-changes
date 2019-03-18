require "rails_helper"

RSpec.describe OverlappingZipCodeController do
  it_behaves_like "form controller base behavior"
  it_behaves_like "form controller successful update", { county: "Arapahoe" }
  it_behaves_like "form controller unsuccessful update"

  describe "show?" do
    let(:report) do
      create(:report, :filled)
    end

    context "zip code overlaps, with one of our valid counties" do
      it "returns true" do
        report.navigator.update(zip_code: "80045")

        show_form = described_class.show?(report)
        expect(show_form).to eq(true)
      end
    end

    context "zip code does not overlap" do
      it "returns false" do
        report.navigator.update(zip_code: "81012")

        show_form = described_class.show?(report)
        expect(show_form).to eq(false)
      end
    end

    context "zip code overlaps, without one of our valid counties" do
      it "returns false" do
        report.navigator.update(zip_code: "80249")

        show_form = described_class.show?(report)
        expect(show_form).to eq(false)
      end
    end
  end
end
