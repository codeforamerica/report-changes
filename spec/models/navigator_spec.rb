require "rails_helper"

RSpec.describe Navigator do
  describe ".supported_county?" do
    context "with arapahoe" do
      it "returns true" do
        report = create :report, county: "Arapahoe"
        navigator = build(:navigator, report: report)

        expect(navigator.supported_county?).to be_truthy
      end
    end

    context "with Pitkin" do
      it "returns true" do
        report = create :report, county: "Arapahoe"
        navigator = build(:navigator, report: report)

        expect(navigator.supported_county?).to be_truthy
      end
    end

    context "with neither selected county location nor county from address matching arapahoe" do
      it "returns false" do
        report = create :report, county: nil
        navigator = build(:navigator, report: report)

        expect(navigator.supported_county?).to be_falsey
      end
    end
  end
end
