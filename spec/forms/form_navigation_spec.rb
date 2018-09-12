require "rails_helper"

RSpec.describe FormNavigation do
  before(:each) do
    class FirstController; end
    class SecondController; end
    class ThirdController; end

    stub_const("FormNavigation::MAIN",
               [
                 FirstController,
                 SecondController,
                 ThirdController,
               ])
  end

  describe ".form_controllers" do
    it "returns the main flow, not including groupings" do
      expect(FormNavigation.form_controllers).to match_array(
        [
          FirstController,
          SecondController,
          ThirdController,
        ],
      )
    end
  end

  describe ".first" do
    it "delegates to .form_controllers" do
      expect(FormNavigation.first).to eq(FirstController)
    end
  end

  describe "#next" do
    context "when current controller is not the last" do
      it "returns the next controller in the list" do
        navigation = FormNavigation.new(FirstController.new)
        expect(navigation.next).to eq SecondController
      end
    end

    context "when current controller is the last" do
      it "returns nil" do
        navigation = FormNavigation.new(ThirdController.new)
        expect(navigation.next).to be_nil
      end
    end
  end
end
