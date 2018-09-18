require "rails_helper"

RSpec.describe HowItWorksController do
  it_behaves_like "form controller"

  describe "show?" do
    it "is always true" do
      show_form = HowItWorksController.show?(nil)
      expect(show_form).to eq(true)
    end
  end
end
