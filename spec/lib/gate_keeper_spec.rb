require "rails_helper"

describe GateKeeper do
  describe ".demo_environment?" do
    context "and DEMO_MODE is false" do
      it "returns false" do
        expect(GateKeeper.demo_environment?).to eq(false)
      end
    end

    context "and DEMO_MODE is true" do
      it "returns true" do
        with_modified_env DEMO_MODE: "true" do
          expect(GateKeeper.demo_environment?).to eq(true)
        end
      end
    end
  end

  describe ".feature_enabled?" do
    context "when environment variable is set" do
      it "returns true" do
        with_modified_env BEST_THING_ENABLED: "true" do
          expect(GateKeeper.feature_enabled?("BEST_THING")).to eq(true)
        end
      end
    end

    context "when environment variable is not set" do
      it "returns false" do
        expect(GateKeeper.feature_enabled?("BEST_THING")).to eq(false)
      end
    end
  end
end
