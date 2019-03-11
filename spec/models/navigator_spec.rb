require "rails_helper"

RSpec.describe Navigator do
  describe ".supported_county?" do
    let(:report) { build(:report) }

    context "with arapahoe" do
      it "returns true" do
        navigator = build(:navigator,
                           county: "Arapahoe",
                           report: report)

        expect(navigator.supported_county?).to be_truthy
      end
    end

    context "with neither selected county location nor county from address matching arapahoe" do
      it "returns false" do
        navigator = build(:navigator,
                           county: nil,
                           report: report)

        expect(navigator.supported_county?).to be_falsey
      end
    end
  end
end
