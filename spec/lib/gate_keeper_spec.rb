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
end
