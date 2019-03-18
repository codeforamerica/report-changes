require "rails_helper"

RSpec.describe Navigator do
  let(:report) { create :report, :filled }

  describe "#supported_county?" do
    context "with arapahoe" do
      it "returns true" do
        report.update county: "Arapahoe"

        expect(report.navigator.supported_county?).to be_truthy
      end
    end

    context "with Pitkin" do
      it "returns true" do
        report.update county: "Pitkin"

        expect(report.navigator.supported_county?).to be_truthy
      end
    end

    context "with no county" do
      it "returns false" do
        report.update county: nil

        expect(report.navigator.supported_county?).to be_falsey
      end
    end
  end

  describe "#zip_code_in_supported_county?" do
    context "with arapahoe zipcode" do
      it "returns true" do
        # "Arapahoe", "Denver", "Jefferson"
        report.navigator.update zip_code: "80123"

        expect(report.navigator.zip_code_includes_supported_county?).to be_truthy
      end
    end

    context "with Pitkin zipcode" do
      it "returns true" do
        # "Eagle", "Pitkin"
        report.navigator.update zip_code: "81642"

        expect(report.navigator.zip_code_includes_supported_county?).to be_truthy
      end
    end

    context "with neither selected county location nor county from address matching arapahoe" do
      it "returns false" do
        # "Jackson", "Larimer"
        report.navigator.update zip_code: "80430"

        expect(report.navigator.zip_code_includes_supported_county?).to be_falsey
      end
    end
  end
end
